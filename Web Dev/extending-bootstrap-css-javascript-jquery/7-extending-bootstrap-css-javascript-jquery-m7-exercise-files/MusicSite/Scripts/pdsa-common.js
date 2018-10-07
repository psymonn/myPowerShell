$(document).ready(function () {
  $('body').removeClass('notransition');
});

/* Use to display a progress message */
function DisplayProgressMessage(ctl, msg) {
  // Disable the button and change text
  $(ctl).prop("disabled", true).text(msg);
  // Gray out background on page
  $("body").addClass("pdsa-submit-progress-bg");

  // Wrap in setTimeout so the UI can update the spinners
  setTimeout(function () {
    $(".pdsa-submit-progress").removeClass("hidden");
  }, 0);

  return true;
}