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
    
    // Add copy functionality to all prototype screens
    addCopyButtons();
});

// Function to add copy buttons to all prototype screens
function addCopyButtons() {
    // Add copy buttons to each prototype screen
    document.querySelectorAll('.prototype-screen').forEach((screen, index) => {
        // Create copy button
        const copyBtn = document.createElement('button');
        copyBtn.className = 'copy-btn';
        copyBtn.innerHTML = '<span class="copy-icon">📋</span> Copy HTML';
        copyBtn.setAttribute('data-index', index);
        
        // Add button to screen header
        const header = screen.querySelector('h3');
        header.appendChild(copyBtn);
        
        // Add click event
        copyBtn.addEventListener('click', function() {
            const screenIndex = this.getAttribute('data-index');
            const screenContent = document.querySelectorAll('.prototype-screen')[screenIndex];
            
            // Get HTML content to copy
            const htmlToCopy = getFormattedHTML(screenContent);
            
            // Copy to clipboard
            copyToClipboard(htmlToCopy);
            
            // Show feedback
            this.innerHTML = '<span class="copy-icon">✓</span> Copied!';
            setTimeout(() => {
                this.innerHTML = '<span class="copy-icon">📋</span> Copy HTML';
            }, 2000);
        });
    });
    
    // Add copy buttons to code sections
    document.querySelectorAll('.tech-section').forEach((section, index) => {
        // Create copy button
        const copyBtn = document.createElement('button');
        copyBtn.className = 'copy-btn';
        copyBtn.innerHTML = '<span class="copy-icon">📋</span> Copy Text';
        copyBtn.setAttribute('data-index', index);
        
        // Add button to section header
        const header = section.querySelector('h3');
        header.appendChild(copyBtn);
        
        // Add click event
        copyBtn.addEventListener('click', function() {
            const sectionIndex = this.getAttribute('data-index');
            const sectionContent = document.querySelectorAll('.tech-section')[sectionIndex];
            
            // Get text content to copy
            const textToCopy = sectionContent.textContent.trim();
            
            // Copy to clipboard
            copyToClipboard(textToCopy);
            
            // Show feedback
            this.innerHTML = '<span class="copy-icon">✓</span> Copied!';
            setTimeout(() => {
                this.innerHTML = '<span class="copy-icon">📋</span> Copy Text';
            }, 2000);
        });
    });
}

// Function to get formatted HTML for copying
function getFormattedHTML(element) {
    // Clone the element to avoid modifying the original
    const clone = element.cloneNode(true);
    
    // Remove copy buttons from the clone
    clone.querySelectorAll('.copy-btn').forEach(btn => btn.remove());
    
    // Get the HTML content
    return clone.outerHTML;
}

// Function to copy text to clipboard
function copyToClipboard(text) {
    // Create a temporary textarea element
    const textarea = document.createElement('textarea');
    textarea.value = text;
    textarea.setAttribute('readonly', '');
    textarea.style.position = 'absolute';
    textarea.style.left = '-9999px';
    document.body.appendChild(textarea);
    
    // Select and copy the text
    textarea.select();
    document.execCommand('copy');
    
    // Remove the textarea
    document.body.removeChild(textarea);
}