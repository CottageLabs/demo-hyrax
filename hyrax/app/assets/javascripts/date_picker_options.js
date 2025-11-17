Blacklight.onLoad(function() {
 // $.fn.datepicker.defaults.format = "dd/mm/yyyy";
  $('[data-provide="datepicker"]').datepicker({
    orientation: "bottom left",
    dateFormat: "dd/mm/yy"
  });
});
