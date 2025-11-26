/**
 * MediDesk Website - Main JavaScript
 * Handles navigation, smooth scrolling, FAQ accordion, and form interactions
 */

(function() {
    'use strict';

    // ========================================
    // Navigation
    // ========================================
    const navbar = document.getElementById('navbar');
    const mobileMenuBtn = document.getElementById('mobileMenuBtn');
    const navLinks = document.getElementById('navLinks');
    
    // Navbar scroll effect
    window.addEventListener('scroll', function() {
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });
    
    // Mobile menu toggle
    if (mobileMenuBtn && navLinks) {
        mobileMenuBtn.addEventListener('click', function() {
            mobileMenuBtn.classList.toggle('active');
            navLinks.classList.toggle('active');
        });
        
        // Close mobile menu when clicking on a link
        const navLinksItems = navLinks.querySelectorAll('a');
        navLinksItems.forEach(function(link) {
            link.addEventListener('click', function() {
                mobileMenuBtn.classList.remove('active');
                navLinks.classList.remove('active');
            });
        });
    }
    
    // ========================================
    // Smooth Scrolling for Anchor Links
    // ========================================
    document.querySelectorAll('a[href^="#"]').forEach(function(anchor) {
        anchor.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            
            // Skip if href is just "#"
            if (href === '#') {
                e.preventDefault();
                return;
            }
            
            const target = document.querySelector(href);
            if (target) {
                e.preventDefault();
                
                const navbarHeight = navbar ? navbar.offsetHeight : 0;
                const targetPosition = target.offsetTop - navbarHeight - 20;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });
    
    // ========================================
    // FAQ Accordion
    // ========================================
    const faqItems = document.querySelectorAll('.faq-item');
    
    faqItems.forEach(function(item) {
        const question = item.querySelector('.faq-question');
        
        if (question) {
            question.addEventListener('click', function() {
                // Close all other FAQs
                faqItems.forEach(function(otherItem) {
                    if (otherItem !== item) {
                        otherItem.classList.remove('active');
                    }
                });
                
                // Toggle current FAQ
                item.classList.toggle('active');
            });
        }
    });
    
    // ========================================
    // Back to Top Button
    // ========================================
    const backToTopBtn = document.getElementById('backToTop');
    
    if (backToTopBtn) {
        window.addEventListener('scroll', function() {
            if (window.scrollY > 500) {
                backToTopBtn.classList.add('visible');
            } else {
                backToTopBtn.classList.remove('visible');
            }
        });
        
        backToTopBtn.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }
    
    // ========================================
    // Form Handling
    // ========================================
    
    // Quote Form
    const quoteForm = document.getElementById('quoteForm');
    if (quoteForm) {
        quoteForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form data
            const formData = new FormData(quoteForm);
            const data = {
                firstname: formData.get('firstname'),
                lastname: formData.get('lastname'),
                email: formData.get('email'),
                phone: formData.get('phone'),
                cabinetType: formData.get('cabinet-type'),
                practitioners: formData.get('practitioners'),
                appointments: formData.get('appointments'),
                modules: formData.getAll('modules'),
                message: formData.get('message'),
                consent: formData.get('consent')
            };
            
            // Validation
            if (!data.consent) {
                alert('Veuillez accepter d\'être contacté pour continuer.');
                return;
            }
            
            if (data.modules.length === 0) {
                alert('Veuillez sélectionner au moins un module.');
                return;
            }
            
            // Show success message
            showSuccessMessage(quoteForm, 
                '✅ Demande de devis envoyée avec succès ! Nous vous recontacterons sous 48h ouvrées.'
            );
            
            // Log data (in production, send to backend)
            console.log('Quote request:', data);
            
            // Reset form
            quoteForm.reset();
        });
    }
    
    // General Contact Form
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form data
            const formData = new FormData(contactForm);
            const data = {
                name: formData.get('name'),
                email: formData.get('email'),
                message: formData.get('message')
            };
            
            // Show success message
            showSuccessMessage(contactForm, 
                '✅ Message envoyé avec succès ! Nous vous répondrons sous 24h.'
            );
            
            // Log data (in production, send to backend)
            console.log('Contact message:', data);
            
            // Reset form
            contactForm.reset();
        });
    }
    
    // Helper function to show success message
    function showSuccessMessage(form, message) {
        const successDiv = document.createElement('div');
        successDiv.className = 'form-success-message';
        successDiv.textContent = message;
        successDiv.style.cssText = `
            padding: 1rem;
            margin-top: 1rem;
            background: #dcfce7;
            color: #166534;
            border-radius: 0.5rem;
            font-weight: 600;
            text-align: center;
            animation: fadeInUp 0.5s ease-out;
        `;
        
        // Remove any existing success message
        const existingMessage = form.querySelector('.form-success-message');
        if (existingMessage) {
            existingMessage.remove();
        }
        
        // Add new success message
        form.appendChild(successDiv);
        
        // Remove success message after 5 seconds
        setTimeout(function() {
            successDiv.style.opacity = '0';
            successDiv.style.transition = 'opacity 0.5s ease-out';
            setTimeout(function() {
                successDiv.remove();
            }, 500);
        }, 5000);
        
        // Scroll to success message
        successDiv.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
    
    // ========================================
    // Scroll Reveal Animation
    // ========================================
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -100px 0px'
    };
    
    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in-up');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);
    
    // Observe elements
    const animateElements = document.querySelectorAll(
        '.feature-card, .pricing-card, .faq-item, .contact-card, .ps-problem, .ps-solution'
    );
    
    animateElements.forEach(function(element) {
        observer.observe(element);
    });
    
    // ========================================
    // External Links
    // ========================================
    document.querySelectorAll('a[target="_blank"]').forEach(function(link) {
        link.setAttribute('rel', 'noopener noreferrer');
    });
    
    // ========================================
    // Initialize
    // ========================================
    console.log('✅ MediDesk website initialized');
    
})();
