"""
MediDesk - Backend API Stripe pour gestion abonnements
=====================================================

Ce fichier implémente l'API Flask pour gérer les abonnements Stripe
de MediDesk. À intégrer avec le backend principal.

Installation requise:
pip install flask stripe python-dotenv

Configuration .env:
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
"""

from flask import Flask, request, jsonify
import stripe
import os
from datetime import datetime, timedelta
from functools import wraps

# === CONFIGURATION ===
app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')

# Stripe configuration
stripe.api_key = os.getenv('STRIPE_SECRET_KEY', 'sk_test_YOUR_KEY_HERE')
STRIPE_PUBLISHABLE_KEY = os.getenv('STRIPE_PUBLISHABLE_KEY', 'pk_test_YOUR_KEY_HERE')
STRIPE_WEBHOOK_SECRET = os.getenv('STRIPE_WEBHOOK_SECRET', 'whsec_YOUR_SECRET_HERE')

# Plans configuration (IDs à créer dans Stripe Dashboard)
PLANS = {
    'starter': {
        'name': 'Starter',
        'price_id': 'price_starter_monthly',  # À remplacer par vrai ID Stripe
        'amount': 1900,  # 19.00 EUR en centimes
        'features': ['1 praticien', '50 patients max', 'Fonctionnalités de base']
    },
    'professional': {
        'name': 'Professional',
        'price_id': 'price_pro_monthly',
        'amount': 4900,
        'features': ['1-3 praticiens', '200 patients max', 'Sync cloud', 'Facturation auto']
    },
    'cabinet': {
        'name': 'Cabinet',
        'price_id': 'price_cabinet_monthly',
        'amount': 9900,
        'features': ['Praticiens illimités', 'Patients illimités', 'Multi-sites', 'API']
    }
}

# === AUTHENTIFICATION MIDDLEWARE ===
def require_auth(f):
    """Vérifie que l'utilisateur est authentifié (JWT token)"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        token = request.headers.get('Authorization')
        if not token:
            return jsonify({'error': 'Token requis'}), 401
        
        # TODO: Vérifier JWT token avec le backend principal
        # Pour l'instant, on accepte tous les tokens (DEV ONLY)
        
        return f(*args, **kwargs)
    return decorated_function


# === ENDPOINTS API ===

@app.route('/api/stripe/config', methods=['GET'])
def get_stripe_config():
    """Retourne la clé publique Stripe pour le frontend"""
    return jsonify({
        'publishableKey': STRIPE_PUBLISHABLE_KEY,
        'plans': PLANS
    })


@app.route('/api/stripe/create-checkout-session', methods=['POST'])
@require_auth
def create_checkout_session():
    """
    Crée une session Stripe Checkout pour un abonnement
    
    Body:
    {
        "plan": "professional",  # starter, professional, cabinet
        "user_id": "user_123",
        "email": "user@example.com"
    }
    """
    try:
        data = request.get_json()
        plan_name = data.get('plan')
        user_id = data.get('user_id')
        user_email = data.get('email')
        
        if plan_name not in PLANS:
            return jsonify({'error': 'Plan invalide'}), 400
        
        plan = PLANS[plan_name]
        
        # Créer session Stripe Checkout
        checkout_session = stripe.checkout.Session.create(
            customer_email=user_email,
            payment_method_types=['card'],
            mode='subscription',
            line_items=[{
                'price': plan['price_id'],
                'quantity': 1,
            }],
            success_url='https://medidesk.fr/success?session_id={CHECKOUT_SESSION_ID}',
            cancel_url='https://medidesk.fr/cancel',
            metadata={
                'user_id': user_id,
                'plan': plan_name
            },
            subscription_data={
                'trial_period_days': 14,  # 14 jours d'essai gratuit
                'metadata': {
                    'user_id': user_id
                }
            }
        )
        
        return jsonify({
            'sessionId': checkout_session.id,
            'url': checkout_session.url
        })
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/stripe/create-portal-session', methods=['POST'])
@require_auth
def create_portal_session():
    """
    Crée une session Stripe Customer Portal pour gérer l'abonnement
    
    Body:
    {
        "customer_id": "cus_xxx"
    }
    """
    try:
        data = request.get_json()
        customer_id = data.get('customer_id')
        
        if not customer_id:
            return jsonify({'error': 'customer_id requis'}), 400
        
        portal_session = stripe.billing_portal.Session.create(
            customer=customer_id,
            return_url='https://medidesk.fr/account',
        )
        
        return jsonify({'url': portal_session.url})
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/stripe/subscription-status', methods=['GET'])
@require_auth
def get_subscription_status():
    """
    Récupère le statut d'abonnement d'un utilisateur
    
    Query params:
    ?user_id=user_123
    """
    try:
        user_id = request.args.get('user_id')
        
        if not user_id:
            return jsonify({'error': 'user_id requis'}), 400
        
        # TODO: Récupérer customer_id depuis votre DB via user_id
        # customer_id = get_customer_id_from_db(user_id)
        
        # Pour l'instant, retour mock data
        return jsonify({
            'active': True,
            'plan': 'professional',
            'status': 'active',
            'current_period_end': (datetime.now() + timedelta(days=30)).isoformat(),
            'cancel_at_period_end': False
        })
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/stripe/cancel-subscription', methods=['POST'])
@require_auth
def cancel_subscription():
    """
    Annule un abonnement (à la fin de la période)
    
    Body:
    {
        "subscription_id": "sub_xxx"
    }
    """
    try:
        data = request.get_json()
        subscription_id = data.get('subscription_id')
        
        if not subscription_id:
            return jsonify({'error': 'subscription_id requis'}), 400
        
        # Annuler à la fin de la période
        subscription = stripe.Subscription.modify(
            subscription_id,
            cancel_at_period_end=True
        )
        
        return jsonify({
            'success': True,
            'cancel_at': subscription.cancel_at
        })
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/stripe/webhook', methods=['POST'])
def stripe_webhook():
    """
    Webhook Stripe pour gérer les événements d'abonnement
    
    Événements gérés:
    - customer.subscription.created
    - customer.subscription.updated
    - customer.subscription.deleted
    - invoice.payment_succeeded
    - invoice.payment_failed
    """
    payload = request.data
    sig_header = request.headers.get('Stripe-Signature')
    
    try:
        event = stripe.Webhook.construct_event(
            payload, sig_header, STRIPE_WEBHOOK_SECRET
        )
    except ValueError:
        return jsonify({'error': 'Invalid payload'}), 400
    except stripe.error.SignatureVerificationError:
        return jsonify({'error': 'Invalid signature'}), 400
    
    # Gérer différents types d'événements
    if event['type'] == 'customer.subscription.created':
        subscription = event['data']['object']
        user_id = subscription['metadata'].get('user_id')
        
        # TODO: Mettre à jour votre DB
        print(f"✅ Abonnement créé pour user {user_id}")
        # update_user_subscription(user_id, 'active', subscription['id'])
        
    elif event['type'] == 'customer.subscription.updated':
        subscription = event['data']['object']
        user_id = subscription['metadata'].get('user_id')
        
        print(f"🔄 Abonnement mis à jour pour user {user_id}")
        # update_user_subscription(user_id, subscription['status'], subscription['id'])
        
    elif event['type'] == 'customer.subscription.deleted':
        subscription = event['data']['object']
        user_id = subscription['metadata'].get('user_id')
        
        print(f"❌ Abonnement annulé pour user {user_id}")
        # update_user_subscription(user_id, 'canceled', None)
        
    elif event['type'] == 'invoice.payment_succeeded':
        invoice = event['data']['object']
        customer_id = invoice['customer']
        
        print(f"💰 Paiement réussi pour customer {customer_id}")
        # send_payment_confirmation_email(customer_id)
        
    elif event['type'] == 'invoice.payment_failed':
        invoice = event['data']['object']
        customer_id = invoice['customer']
        
        print(f"⚠️ Échec paiement pour customer {customer_id}")
        # send_payment_failed_email(customer_id)
    
    return jsonify({'success': True})


# === FONCTIONS HELPER ===

def get_or_create_stripe_customer(user_email, user_id):
    """Crée ou récupère un customer Stripe"""
    try:
        # Chercher customer existant
        customers = stripe.Customer.list(email=user_email, limit=1)
        
        if customers.data:
            return customers.data[0]
        
        # Créer nouveau customer
        customer = stripe.Customer.create(
            email=user_email,
            metadata={'user_id': user_id}
        )
        
        return customer
        
    except Exception as e:
        print(f"Erreur création customer: {e}")
        raise


def create_stripe_price(plan_name, amount, currency='eur'):
    """
    Crée un prix Stripe (à exécuter une seule fois en setup)
    
    Usage:
    price = create_stripe_price('Starter', 1900, 'eur')
    print(price.id)  # price_xxx à mettre dans PLANS
    """
    try:
        # Créer produit
        product = stripe.Product.create(
            name=f"MediDesk {plan_name}",
            description=f"Abonnement mensuel {plan_name}"
        )
        
        # Créer prix récurrent
        price = stripe.Price.create(
            product=product.id,
            unit_amount=amount,
            currency=currency,
            recurring={'interval': 'month'}
        )
        
        return price
        
    except Exception as e:
        print(f"Erreur création prix: {e}")
        raise


# === SETUP INITIAL (à exécuter une fois) ===
def setup_stripe_products():
    """
    Crée les produits et prix Stripe
    À exécuter une seule fois au démarrage
    """
    print("🚀 Configuration produits Stripe...")
    
    for plan_key, plan_data in PLANS.items():
        try:
            price = create_stripe_price(
                plan_data['name'],
                plan_data['amount']
            )
            print(f"✅ {plan_data['name']}: {price.id}")
            print(f"   → Ajouter dans PLANS['{plan_key}']['price_id'] = '{price.id}'")
        except Exception as e:
            print(f"❌ Erreur {plan_data['name']}: {e}")


# === POINT D'ENTRÉE ===
if __name__ == '__main__':
    # Mode développement
    print("=" * 50)
    print("🏥 MediDesk - API Stripe Backend")
    print("=" * 50)
    print(f"📦 Plans disponibles: {', '.join(PLANS.keys())}")
    print(f"🔑 Stripe Key: {stripe.api_key[:10]}...")
    print()
    print("⚠️  IMPORTANT: Configurer les variables d'environnement:")
    print("   - STRIPE_SECRET_KEY")
    print("   - STRIPE_PUBLISHABLE_KEY")
    print("   - STRIPE_WEBHOOK_SECRET")
    print()
    print("📝 Pour créer les produits Stripe:")
    print("   python backend_stripe.py --setup")
    print()
    
    import sys
    if '--setup' in sys.argv:
        setup_stripe_products()
    else:
        app.run(debug=True, port=5001)
