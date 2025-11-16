// ========================================
// MediDesk Marketing Website - JavaScript
// ========================================

document.addEventListener('DOMContentLoaded', function() {
    // === SMOOTH SCROLLING ===
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                const offset = 80; // Navbar height
                const targetPosition = target.offsetTop - offset;
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });

    // === MOBILE MENU TOGGLE ===
    const mobileMenuBtn = document.getElementById('mobileMenuBtn');
    const navLinks = document.querySelector('.nav-links');
    
    if (mobileMenuBtn) {
        mobileMenuBtn.addEventListener('click', function() {
            navLinks.classList.toggle('active');
            this.classList.toggle('active');
        });
    }

    // === NAVBAR SCROLL EFFECT ===
    let lastScroll = 0;
    const navbar = document.querySelector('.navbar');
    
    window.addEventListener('scroll', function() {
        const currentScroll = window.pageYOffset;
        
        if (currentScroll > 100) {
            navbar.style.boxShadow = '0 2px 10px rgba(0, 0, 0, 0.1)';
        } else {
            navbar.style.boxShadow = 'none';
        }
        
        lastScroll = currentScroll;
    });

    // === CONTACT FORM HANDLING ===
    const contactForm = document.getElementById('contactForm');
    
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form data
            const formData = {
                name: document.getElementById('name').value,
                email: document.getElementById('email').value,
                phone: document.getElementById('phone').value,
                cabinet: document.getElementById('cabinet').value,
                message: document.getElementById('message').value
            };
            
            // Show success message (in production, send to backend)
            alert('Merci pour votre message ! Nous vous recontacterons sous 24h.\n\n' +
                  'Email de confirmation envoyé à : ' + formData.email);
            
            // Reset form
            contactForm.reset();
            
            // In production, replace with actual API call:
            /*
            fetch('/api/contact', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showSuccessMessage('Message envoyé avec succès !');
                    contactForm.reset();
                } else {
                    showErrorMessage('Erreur lors de l\'envoi. Réessayez.');
                }
            })
            .catch(error => {
                showErrorMessage('Erreur réseau. Réessayez.');
            });
            */
        });
    }

    // === INTERSECTION OBSERVER (Animate on scroll) ===
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in-up');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    // Observe all feature cards
    document.querySelectorAll('.feature-card, .pricing-card, .faq-item').forEach(el => {
        observer.observe(el);
    });

    // === STATS COUNTER ANIMATION ===
    function animateCounter(element, target, duration = 2000) {
        const start = 0;
        const increment = target / (duration / 16); // 60fps
        let current = start;
        
        const timer = setInterval(() => {
            current += increment;
            if (current >= target) {
                element.textContent = target;
                clearInterval(timer);
            } else {
                element.textContent = Math.floor(current);
            }
        }, 16);
    }

    // Animate stats when visible
    const statsObserver = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const statValue = entry.target.querySelector('.stat-value');
                if (statValue && !statValue.classList.contains('animated')) {
                    const targetValue = statValue.textContent;
                    if (!isNaN(targetValue)) {
                        animateCounter(statValue, parseInt(targetValue));
                        statValue.classList.add('animated');
                    }
                }
            }
        });
    }, { threshold: 0.5 });

    document.querySelectorAll('.stat').forEach(stat => {
        statsObserver.observe(stat);
    });

    // === PRICING TOGGLE (Annual/Monthly) - Placeholder ===
    // Can be activated later if annual pricing is added
    
    // === DEMO VIDEO MODAL (Placeholder) ===
    const demoLinks = document.querySelectorAll('a[href="#demo"]');
    demoLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            alert('🎥 Démo vidéo à venir !\n\nEn attendant, contactez-nous pour une démo personnalisée en visio.');
            // In production, open video modal or redirect to demo page
        });
    });

    // === EMAIL VALIDATION ===
    function validateEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    }

    // === HELPER FUNCTIONS ===
    function showSuccessMessage(message) {
        const alert = document.createElement('div');
        alert.className = 'alert alert-success';
        alert.textContent = message;
        alert.style.cssText = `
            position: fixed;
            top: 100px;
            right: 20px;
            background: #10b981;
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            z-index: 9999;
            animation: slideInRight 0.3s ease;
        `;
        document.body.appendChild(alert);
        setTimeout(() => alert.remove(), 3000);
    }

    function showErrorMessage(message) {
        const alert = document.createElement('div');
        alert.className = 'alert alert-error';
        alert.textContent = message;
        alert.style.cssText = `
            position: fixed;
            top: 100px;
            right: 20px;
            background: #ef4444;
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            z-index: 9999;
            animation: slideInRight 0.3s ease;
        `;
        document.body.appendChild(alert);
        setTimeout(() => alert.remove(), 3000);
    }

    // === COPY TO CLIPBOARD (for code snippets if needed) ===
    function copyToClipboard(text) {
        navigator.clipboard.writeText(text).then(() => {
            showSuccessMessage('Copié dans le presse-papiers !');
        });
    }

    // === TRACK CTA CLICKS (for analytics) ===
    document.querySelectorAll('.btn-primary, .btn-secondary').forEach(button => {
        button.addEventListener('click', function() {
            const buttonText = this.textContent.trim();
            console.log('CTA clicked:', buttonText);
            
            // In production, send to analytics:
            /*
            gtag('event', 'click', {
                'event_category': 'CTA',
                'event_label': buttonText
            });
            */
        });
    });

    // === LAZY LOAD IMAGES (if images are added later) ===
    if ('IntersectionObserver' in window) {
        const lazyImages = document.querySelectorAll('img[data-src]');
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.src = img.dataset.src;
                    img.removeAttribute('data-src');
                    imageObserver.unobserve(img);
                }
            });
        });

        lazyImages.forEach(img => imageObserver.observe(img));
    }

    // === CONSOLE BRANDING ===
    console.log('%c🏥 MediDesk', 'font-size: 24px; font-weight: bold; color: #2563eb;');
    console.log('%cLogiciel open source pour kinésithérapeutes', 'font-size: 14px; color: #6b7280;');
    console.log('%c💚 Code disponible sur GitHub: https://github.com/RBSoftwareAI/kine', 'font-size: 12px; color: #10b981;');
});

// === KEYBOARD SHORTCUTS (Easter egg) ===
document.addEventListener('keydown', function(e) {
    // Ctrl+K = Open search (future feature)
    if (e.ctrlKey && e.key === 'k') {
        e.preventDefault();
        console.log('Recherche rapide (à implémenter)');
    }
    
    // Esc = Close modals (future feature)
    if (e.key === 'Escape') {
        console.log('Fermeture modals (à implémenter)');
    }
});
