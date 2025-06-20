/**
 * Toggles password field visibility
 * @param {string} fieldId - The ID of the password input field
 */
function togglePassword(fieldId) {
    const passwordField = document.getElementById(fieldId);
    const toggleIcon = passwordField.nextElementSibling.querySelector('i');
    
    if (passwordField.type === "password") {
        passwordField.type = "text";
        toggleIcon.classList.replace('fa-eye', 'fa-eye-slash');
    } else {
        passwordField.type = "password";
        toggleIcon.classList.replace('fa-eye-slash', 'fa-eye');
    }
}

/**
 * Validates password change form
 */
function validatePasswordChange() {
    const currentPassword = document.getElementById('currentPassword').value;
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const errorElement = document.getElementById('passwordError');
    
    // Clear previous errors
    errorElement.innerHTML = '';
    
    // Check password requirements
    if (newPassword.length < 8) {
        showError('Password must be at least 8 characters long');
        return false;
    }
    
    if (!/\d/.test(newPassword)) {
        showError('Password must contain at least one number');
        return false;
    }
    
    if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(newPassword)) {
        showError('Password must contain at least one special character');
        return false;
    }
    
    if (newPassword !== confirmPassword) {
        showError('Passwords do not match');
        return false;
    }
    
    if (currentPassword === newPassword) {
        showError('New password must be different from current password');
        return false;
    }
    
    return true;
    
    function showError(message) {
        errorElement.innerHTML = `<div class="alert alert-danger">${message}</div>`;
    }
}

/**
 * Basic form validation
 */
document.addEventListener('DOMContentLoaded', function() {
    // Apply to all forms with client-side validation
    document.querySelectorAll('form').forEach(form => {
        form.addEventListener('submit', function(e) {
            const requiredFields = form.querySelectorAll('[required]');
            let isValid = true;
            
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    isValid = false;
                    field.classList.add('is-invalid');
                } else {
                    field.classList.remove('is-invalid');
                }
            });
            
            if (!isValid) {
                e.preventDefault();
                alert('Please fill in all required fields');
                return false;
            }
            return true;
        });
    });
});