"""
MediDesk - Backend API pour Formulaires de Contact
==================================================

Ce fichier implémente l'API Flask pour gérer :
1. Formulaires bêta-testeurs (Phase 0/1)
2. Formulaires demandes de démo personnalisée

Installation requise:
pip install flask flask-cors python-dotenv

Configuration .env:
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=contact@medidesk.fr
EMAIL_PASSWORD=your_app_password
EMAIL_TO=contact@medidesk.fr
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import os
from datetime import datetime
import json
import logging

# === CONFIGURATION ===
app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Logging configuration
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Email configuration (from environment variables or defaults)
EMAIL_HOST = os.getenv('EMAIL_HOST', 'smtp.gmail.com')
EMAIL_PORT = int(os.getenv('EMAIL_PORT', 587))
EMAIL_USER = os.getenv('EMAIL_USER', 'contact@medidesk.fr')
EMAIL_PASSWORD = os.getenv('EMAIL_PASSWORD', '')
EMAIL_TO = os.getenv('EMAIL_TO', 'contact@medidesk.fr')

# Database simulation (JSON file - for simple demo)
# In production, use a real database like PostgreSQL or Firebase
SUBMISSIONS_FILE = 'contact_submissions.json'


# === UTILITY FUNCTIONS ===

def save_submission(submission_type, data):
    """Save submission to JSON file for logging purposes"""
    try:
        # Load existing submissions
        if os.path.exists(SUBMISSIONS_FILE):
            with open(SUBMISSIONS_FILE, 'r', encoding='utf-8') as f:
                submissions = json.load(f)
        else:
            submissions = []
        
        # Add new submission
        submission = {
            'type': submission_type,
            'timestamp': datetime.now().isoformat(),
            'data': data
        }
        submissions.append(submission)
        
        # Save back to file
        with open(SUBMISSIONS_FILE, 'w', encoding='utf-8') as f:
            json.dump(submissions, f, indent=2, ensure_ascii=False)
        
        logger.info(f"Submission saved: {submission_type}")
        return True
    except Exception as e:
        logger.error(f"Error saving submission: {e}")
        return False


def send_email(subject, body_html, recipient=None):
    """Send email notification"""
    try:
        # If no recipient specified, use default
        if recipient is None:
            recipient = EMAIL_TO
        
        # Create message
        msg = MIMEMultipart('alternative')
        msg['From'] = EMAIL_USER
        msg['To'] = recipient
        msg['Subject'] = subject
        
        # Attach HTML body
        html_part = MIMEText(body_html, 'html', 'utf-8')
        msg.attach(html_part)
        
        # Send email
        if EMAIL_PASSWORD:  # Only send if password is configured
            server = smtplib.SMTP(EMAIL_HOST, EMAIL_PORT)
            server.starttls()
            server.login(EMAIL_USER, EMAIL_PASSWORD)
            server.send_message(msg)
            server.quit()
            logger.info(f"Email sent: {subject}")
            return True
        else:
            logger.warning("Email not sent: EMAIL_PASSWORD not configured")
            return False
    except Exception as e:
        logger.error(f"Error sending email: {e}")
        return False


def validate_beta_form(data):
    """Validate beta tester form data"""
    required_fields = ['name', 'email', 'profession', 'city']
    for field in required_fields:
        if not data.get(field):
            return False, f"Field '{field}' is required"
    return True, None


def validate_demo_form(data):
    """Validate demo request form data"""
    required_fields = ['name', 'email', 'cabinet_type']
    for field in required_fields:
        if not data.get(field):
            return False, f"Field '{field}' is required"
    return True, None


# === API ENDPOINTS ===

@app.route('/api/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'ok',
        'timestamp': datetime.now().isoformat()
    })


@app.route('/api/beta-tester', methods=['POST'])
def beta_tester_submission():
    """Handle beta tester form submission"""
    try:
        data = request.get_json()
        logger.info(f"Beta tester submission received: {data.get('email', 'unknown')}")
        
        # Validate data
        is_valid, error_msg = validate_beta_form(data)
        if not is_valid:
            return jsonify({
                'success': False,
                'error': error_msg
            }), 400
        
        # Save submission
        save_submission('beta_tester', data)
        
        # Prepare email
        subject = f"🎯 Nouveau Bêta-Testeur : {data['name']}"
        body_html = f"""
        <html>
        <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
            <h2 style="color: #2563eb;">Nouvelle Inscription Bêta-Testeur MediDesk</h2>
            
            <div style="background: #f3f4f6; padding: 20px; border-radius: 8px; margin: 20px 0;">
                <p><strong>Nom :</strong> {data['name']}</p>
                <p><strong>Email :</strong> {data['email']}</p>
                <p><strong>Profession :</strong> {data['profession']}</p>
                <p><strong>Ville :</strong> {data['city']}</p>
                {f"<p><strong>Message :</strong><br>{data['message']}</p>" if data.get('message') else ''}
            </div>
            
            <p style="margin-top: 30px; color: #6b7280; font-size: 14px;">
                Date : {datetime.now().strftime('%d/%m/%Y à %H:%M')}
            </p>
        </body>
        </html>
        """
        
        # Send email notification
        send_email(subject, body_html)
        
        # Send confirmation email to applicant
        confirmation_subject = "Bienvenue dans le programme pilote MediDesk ! 🎉"
        confirmation_body = f"""
        <html>
        <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
            <h2 style="color: #2563eb;">Bienvenue {data['name']} !</h2>
            
            <p>Merci pour votre inscription au programme pilote MediDesk. 🙏</p>
            
            <p>Nous avons bien reçu votre candidature pour devenir bêta-testeur. 
            Notre équipe va l'examiner et vous contactera <strong>dans les 48h</strong> 
            pour discuter de la prochaine étape.</p>
            
            <div style="background: #ecfdf5; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #10b981;">
                <h3 style="margin-top: 0; color: #059669;">Ce que vous recevrez :</h3>
                <ul>
                    <li>✅ Accès prioritaire à toutes les fonctionnalités</li>
                    <li>✅ Installation assistée gratuite (valeur 150€)</li>
                    <li>✅ Support technique dédié</li>
                    <li>✅ Formation personnalisée offerte</li>
                    <li>✅ Modules pro gratuits à vie quand ils sortiront</li>
                </ul>
            </div>
            
            <p>En attendant, vous pouvez tester la démo en ligne :</p>
            <p style="text-align: center; margin: 30px 0;">
                <a href="https://demo.medidesk.fr" 
                   style="background: #2563eb; color: white; padding: 12px 24px; 
                          border-radius: 8px; text-decoration: none; display: inline-block; 
                          font-weight: 600;">
                    Essayer la démo
                </a>
            </p>
            
            <p>À très bientôt ! 🚀</p>
            
            <p style="margin-top: 40px; color: #6b7280; font-size: 14px;">
                L'équipe MediDesk<br>
                <a href="https://medidesk.fr" style="color: #2563eb;">https://medidesk.fr</a>
            </p>
        </body>
        </html>
        """
        send_email(confirmation_subject, confirmation_body, recipient=data['email'])
        
        return jsonify({
            'success': True,
            'message': 'Inscription enregistrée avec succès'
        })
        
    except Exception as e:
        logger.error(f"Error processing beta tester submission: {e}")
        return jsonify({
            'success': False,
            'error': 'Internal server error'
        }), 500


@app.route('/api/demo-request', methods=['POST'])
def demo_request_submission():
    """Handle demo request form submission"""
    try:
        data = request.get_json()
        logger.info(f"Demo request received: {data.get('email', 'unknown')}")
        
        # Validate data
        is_valid, error_msg = validate_demo_form(data)
        if not is_valid:
            return jsonify({
                'success': False,
                'error': error_msg
            }), 400
        
        # Save submission
        save_submission('demo_request', data)
        
        # Prepare email
        subject = f"📅 Nouvelle Demande de Démo : {data['name']}"
        body_html = f"""
        <html>
        <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
            <h2 style="color: #2563eb;">Nouvelle Demande de Démo Personnalisée</h2>
            
            <div style="background: #f3f4f6; padding: 20px; border-radius: 8px; margin: 20px 0;">
                <p><strong>Nom :</strong> {data['name']}</p>
                <p><strong>Email :</strong> {data['email']}</p>
                {f"<p><strong>Téléphone :</strong> {data['phone']}</p>" if data.get('phone') else ''}
                <p><strong>Type de cabinet :</strong> {data['cabinet_type']}</p>
                {f"<p><strong>Date souhaitée :</strong> {data['preferred_date']}</p>" if data.get('preferred_date') else ''}
                {f"<p><strong>Message :</strong><br>{data['message']}</p>" if data.get('message') else ''}
            </div>
            
            <p style="margin-top: 30px; color: #6b7280; font-size: 14px;">
                Date : {datetime.now().strftime('%d/%m/%Y à %H:%M')}
            </p>
        </body>
        </html>
        """
        
        # Send email notification
        send_email(subject, body_html)
        
        # Send confirmation email to requester
        confirmation_subject = "Demande de démo MediDesk bien reçue 📅"
        confirmation_body = f"""
        <html>
        <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
            <h2 style="color: #2563eb;">Bonjour {data['name']} !</h2>
            
            <p>Merci pour votre demande de démo personnalisée MediDesk. 🙏</p>
            
            <p>Nous avons bien reçu votre demande. 
            Notre équipe vous contactera <strong>sous 24h</strong> pour planifier la démonstration 
            à une date qui vous convient.</p>
            
            <div style="background: #eff6ff; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #2563eb;">
                <h3 style="margin-top: 0; color: #1e40af;">Ce que nous allons vous montrer :</h3>
                <ul>
                    <li>📊 Cartographie corporelle interactive unique</li>
                    <li>👥 Gestion complète des dossiers patients</li>
                    <li>📈 Courbes d'évolution automatiques</li>
                    <li>🔒 Sécurité RGPD et données locales</li>
                    <li>💻 Installation et configuration</li>
                </ul>
            </div>
            
            <p>En attendant, vous pouvez explorer la démo en ligne :</p>
            <p style="text-align: center; margin: 30px 0;">
                <a href="https://demo.medidesk.fr" 
                   style="background: #2563eb; color: white; padding: 12px 24px; 
                          border-radius: 8px; text-decoration: none; display: inline-block; 
                          font-weight: 600;">
                    Essayer la démo
                </a>
            </p>
            
            <p>À très bientôt ! 🚀</p>
            
            <p style="margin-top: 40px; color: #6b7280; font-size: 14px;">
                L'équipe MediDesk<br>
                <a href="https://medidesk.fr" style="color: #2563eb;">https://medidesk.fr</a>
            </p>
        </body>
        </html>
        """
        send_email(confirmation_subject, confirmation_body, recipient=data['email'])
        
        return jsonify({
            'success': True,
            'message': 'Demande enregistrée avec succès'
        })
        
    except Exception as e:
        logger.error(f"Error processing demo request: {e}")
        return jsonify({
            'success': False,
            'error': 'Internal server error'
        }), 500


# === RUN SERVER ===

if __name__ == '__main__':
    logger.info("Starting MediDesk Contact Backend...")
    logger.info(f"Email configured: {EMAIL_USER}")
    
    # Run server
    app.run(
        host='0.0.0.0',
        port=5001,  # Different port from Flutter app (5060)
        debug=True
    )
