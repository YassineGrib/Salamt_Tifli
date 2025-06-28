// Smooth scrolling for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Scroll to top functionality
function scrollToTop() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
}

// Show/hide scroll to top button
window.addEventListener('scroll', function() {
    const scrollTop = document.querySelector('.scroll-top');
    if (window.pageYOffset > 300) {
        scrollTop.classList.add('visible');
    } else {
        scrollTop.classList.remove('visible');
    }
});

// Add animation on scroll
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver(function(entries) {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe all feature cards and screenshot cards
document.querySelectorAll('.feature-card, .screenshot-card').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(30px)';
    el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    observer.observe(el);
});

// Download tracking
document.querySelector('a[href*="app-release.apk"]').addEventListener('click', function() {
    // You can add analytics tracking here
    console.log('App download initiated');
});

// Scroll functionality - wait for DOM to load
document.addEventListener('DOMContentLoaded', function() {
    const container = document.querySelector('.screenshots-container');
    const scrollBtns = document.querySelectorAll('.scroll-btn');
    const indicators = document.querySelectorAll('.indicator');
    const cards = document.querySelectorAll('.screenshot-card');

    if (container && scrollBtns.length > 0) {
        function scrollLeft() {
            container.scrollBy({
                left: -320,
                behavior: 'smooth'
            });
        }

        function scrollRight() {
            container.scrollBy({
                left: 320,
                behavior: 'smooth'
            });
        }

        function scrollToSlide(index) {
            const cardWidth = 320; // card width + gap
            container.scrollTo({
                left: index * cardWidth,
                behavior: 'smooth'
            });
        }

        // Make functions globally available
        window.scrollLeft = scrollLeft;
        window.scrollRight = scrollRight;
        window.scrollToSlide = scrollToSlide;

        // Update button states and indicators based on scroll position
        function updateScrollState() {
            const scrollLeft = container.scrollLeft;
            const maxScroll = container.scrollWidth - container.clientWidth;
            
            // Update button states
            scrollBtns[0].disabled = scrollLeft === 0;
            scrollBtns[1].disabled = scrollLeft >= maxScroll;
            
            // Update indicators
            const currentIndex = Math.round(scrollLeft / 320);
            indicators.forEach((indicator, index) => {
                indicator.classList.toggle('active', index === currentIndex);
            });
        }

        container.addEventListener('scroll', updateScrollState);

        // Initialize states
        updateScrollState();

        // Add click handlers for indicators
        indicators.forEach((indicator, index) => {
            indicator.addEventListener('click', () => scrollToSlide(index));
        });

        // Add keyboard navigation
        document.addEventListener('keydown', function(e) {
            if (e.key === 'ArrowLeft') {
                scrollRight();
            } else if (e.key === 'ArrowRight') {
                scrollLeft();
            }
        });

        // Add touch/swipe support
        let startX = 0;
        let isDragging = false;

        container.addEventListener('touchstart', function(e) {
            startX = e.touches[0].clientX;
            isDragging = true;
        });

        container.addEventListener('touchmove', function(e) {
            if (!isDragging) return;
            e.preventDefault();
        });

        container.addEventListener('touchend', function(e) {
            if (!isDragging) return;
            isDragging = false;
            const endX = e.changedTouches[0].clientX;
            const diff = startX - endX;
            
            if (Math.abs(diff) > 50) {
                if (diff > 0) {
                    scrollRight();
                } else {
                    scrollLeft();
                }
            }
        });
    }
}); 