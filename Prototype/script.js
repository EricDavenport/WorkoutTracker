document.addEventListener('DOMContentLoaded', function() {
    // Smooth scrolling for navigation links
    document.querySelectorAll('nav a').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            const targetElement = document.querySelector(targetId);
            
            window.scrollTo({
                top: targetElement.offsetTop - 70,
                behavior: 'smooth'
            });
        });
    });
    
    // Add active class to current section in navigation
    window.addEventListener('scroll', function() {
        const sections = document.querySelectorAll('section');
        const navLinks = document.querySelectorAll('nav a');
        
        let currentSection = '';
        
        sections.forEach(section => {
            const sectionTop = section.offsetTop - 100;
            const sectionHeight = section.clientHeight;
            
            if (pageYOffset >= sectionTop && pageYOffset < sectionTop + sectionHeight) {
                currentSection = '#' + section.getAttribute('id');
            }
        });
        
        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === currentSection) {
                link.classList.add('active');
            }
        });
    });
    
    // Create placeholder images with text
    document.querySelectorAll('.placeholder-image').forEach(img => {
        if (!img.src.includes('http')) {
            const text = document.createElement('span');
            text.textContent = img.alt || 'Image Placeholder';
            img.appendChild(text);
        }
    });
    
    // Add interactivity to prototype buttons (for demonstration purposes)
    document.querySelectorAll('button').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Add a simple animation to show the button was clicked
            this.classList.add('button-clicked');
            
            setTimeout(() => {
                this.classList.remove('button-clicked');
            }, 300);
        });
    });
    
    // Add CSS for button click animation
    const style = document.createElement('style');
    style.textContent = `
        .button-clicked {
            transform: scale(0.95);
            opacity: 0.8;
            transition: transform 0.3s, opacity 0.3s;
        }
    `;
    document.head.appendChild(style);
});