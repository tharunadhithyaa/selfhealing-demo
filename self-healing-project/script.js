// ============================================
// SELF-HEALING CI/CD PLATFORM - SCRIPT
// ============================================
// This file contains minimal JavaScript.
// The only purpose is to display the current
// date and time in the "Deployed At" card.
// ============================================

/**
 * Sets the deployment time display.
 *
 * In a real CI/CD setup, this timestamp would be
 * injected during the build step. For this demo,
 * we simply show the current date and time when
 * the page loads.
 */
function setDeploymentTime() {
  // Find the element that shows the deployment time
  var element = document.getElementById('deploy-time');

  // Only proceed if the element exists on the page
  if (!element) {
    return;
  }

  // Get the current date and time
  var now = new Date();

  // Format: YYYY-MM-DD HH:MM
  var year   = now.getFullYear();
  var month  = String(now.getMonth() + 1).padStart(2, '0');
  var day    = String(now.getDate()).padStart(2, '0');
  var hours  = String(now.getHours()).padStart(2, '0');
  var mins   = String(now.getMinutes()).padStart(2, '0');

  var formatted = year + '-' + month + '-' + day + ' ' + hours + ':' + mins;

  // Display the formatted time in the card
  element.textContent = formatted;
}

// Run when the page finishes loading
document.addEventListener('DOMContentLoaded', setDeploymentTime);
