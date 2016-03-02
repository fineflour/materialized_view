// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
$(document).ready(function(){
  $('#predictions-table').DataTable( {
    "order": [[ 4, 'asc'], [1, 'asc' ]],
    "bSort": true,
    "pageLength": 30
    // ajax: ...,
    // autoWidth: false,
    // pagingType: 'full_numbers',
    // processing: true,
    // serverSide: true,

    // Optional, if you want full pagination controls.
    // Check dataTables documentation to learn more about available options.
    // http://datatables.net/reference/option/pagingType
  });
});
