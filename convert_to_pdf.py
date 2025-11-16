#!/usr/bin/env python3
"""
Script de conversion HTML vers PDF pour les documents publicitaires MediDesk
Utilise weasyprint pour une conversion de haute qualité
"""

import os
import sys

try:
    from weasyprint import HTML, CSS
    print("✅ weasyprint importé avec succès")
except ImportError:
    print("❌ weasyprint n'est pas installé")
    print("\n📦 INSTALLATION REQUISE:")
    print("pip install weasyprint")
    print("\n💡 Pour Ubuntu/Debian, installez également:")
    print("sudo apt-get install python3-cffi python3-brotli libpango-1.0-0 libpangoft2-1.0-0")
    sys.exit(1)

def convert_html_to_pdf(html_file, pdf_file):
    """Convertit un fichier HTML en PDF"""
    try:
        print(f"\n🔄 Conversion de {html_file} en cours...")
        
        # Charger le HTML
        html = HTML(filename=html_file)
        
        # CSS personnalisé pour l'impression
        css = CSS(string='''
            @page {
                size: A4;
                margin: 15mm;
            }
            @media print {
                body {
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                }
            }
        ''')
        
        # Générer le PDF
        html.write_pdf(pdf_file, stylesheets=[css])
        
        # Vérifier la taille du fichier généré
        file_size = os.path.getsize(pdf_file)
        file_size_mb = file_size / (1024 * 1024)
        
        print(f"✅ PDF généré : {pdf_file}")
        print(f"📊 Taille : {file_size_mb:.2f} MB")
        
        return True
        
    except Exception as e:
        print(f"❌ Erreur lors de la conversion : {e}")
        return False

def main():
    """Fonction principale"""
    print("=" * 60)
    print("🏥 CONVERSION PDF DOCUMENTS PUBLICITAIRES MEDIDESK")
    print("=" * 60)
    
    # Chemin des fichiers
    docs_dir = os.path.join(os.path.dirname(__file__), 'docs')
    
    files_to_convert = [
        {
            'html': os.path.join(docs_dir, 'PUBLICITE_KINES_TOURCOING.html'),
            'pdf': os.path.join(docs_dir, 'PUBLICITE_KINES_TOURCOING.pdf'),
            'description': 'Document Kinésithérapeutes'
        },
        {
            'html': os.path.join(docs_dir, 'PUBLICITE_PATRON_TOURCOING.html'),
            'pdf': os.path.join(docs_dir, 'PUBLICITE_PATRON_TOURCOING.pdf'),
            'description': 'Document Responsable Cabinet'
        }
    ]
    
    success_count = 0
    total_count = len(files_to_convert)
    
    for file_info in files_to_convert:
        print(f"\n📄 {file_info['description']}")
        print(f"   HTML : {os.path.basename(file_info['html'])}")
        print(f"   PDF  : {os.path.basename(file_info['pdf'])}")
        
        if not os.path.exists(file_info['html']):
            print(f"   ❌ Fichier HTML introuvable : {file_info['html']}")
            continue
        
        if convert_html_to_pdf(file_info['html'], file_info['pdf']):
            success_count += 1
    
    print("\n" + "=" * 60)
    print(f"✅ Conversion terminée : {success_count}/{total_count} fichiers")
    print("=" * 60)
    
    if success_count == total_count:
        print("\n🎉 TOUS LES FICHIERS ONT ÉTÉ CONVERTIS AVEC SUCCÈS !")
        print("\n📂 Fichiers PDF disponibles dans :")
        print(f"   {docs_dir}/")
        print("\n📋 Prochaines étapes :")
        print("   1. Ouvrir les PDFs pour vérifier le rendu")
        print("   2. Personnaliser [VOTRE NOM], [NUMÉRO], [EMAIL]")
        print("   3. Imprimer ou envoyer par email")
    else:
        print("\n⚠️  Certains fichiers n'ont pas pu être convertis")
        print("   Vérifiez les erreurs ci-dessus")

if __name__ == "__main__":
    main()
