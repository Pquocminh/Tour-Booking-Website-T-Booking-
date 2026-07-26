/**
 * T-Booking Security & Anti-XSS Script
 * Prevents unauthorized inspecting, right-clicking, F12 developer tools, and XSS script injection.
 */

// 1. Disable right-click context menu (prevents Inspect Element & View Page Source)
document.addEventListener('contextmenu', event => event.preventDefault());

// 2. Disable keyboard shortcuts for Developer Tools and Page Source
document.addEventListener('keydown', function(e) {
    if (e.key === 'F12' || 
       (e.ctrlKey && e.shiftKey && (e.key === 'I' || e.key === 'J' || e.key === 'C')) || 
       (e.ctrlKey && e.key === 'U')) {
        e.preventDefault();
    }
});

// 3. Prevent Cross-Site Scripting (XSS) - Inspect and block form submission if malicious HTML/scripts are detected
document.addEventListener('submit', function(e) {
    const form = e.target;
    const inputs = form.querySelectorAll('input[type="text"], input[type="search"], input[type="url"], input:not([type]), textarea');
    
    // Pattern to detect potentially dangerous HTML tags and event handlers
    const xssPattern = /(<script\b[^>]*>|<\/script>|<iframe\b|<object\b|<embed\b|<applet\b|javascript:|on\w+\s*=|<img\b[^>]*onerror)/i;
    
    for (let input of inputs) {
        if (xssPattern.test(input.value)) {
            e.preventDefault(); // Immediately block form submission
            input.style.border = "2px solid #dc3545"; // Highlight offending input in red
            input.focus();
            
            alert("🚫 T-BOOKING SECURITY ALERT:\n\nPotential malicious code or script tags (<script>, iframe, javascript...) detected in your input!\n\nThe submission has been blocked to prevent Cross-Site Scripting (XSS) attacks.");
            return false;
        } else {
            input.style.border = ""; // Restore normal border if safe
        }
    }
});

// 4. Auto-Sanitization - Automatically strip <script> tags when leaving an input field
document.addEventListener('blur', function(e) {
    if (e.target && (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA')) {
        const originalVal = e.target.value;
        if (originalVal && typeof originalVal === 'string') {
            const cleanedVal = originalVal.replace(/<\/?script\b[^>]*>/gi, "")
                                          .replace(/javascript:/gi, "");
            if (originalVal !== cleanedVal) {
                e.target.value = cleanedVal;
                console.warn("[T-Booking Security] Automatically sanitized <script> tags from input.");
            }
        }
    }
}, true);
