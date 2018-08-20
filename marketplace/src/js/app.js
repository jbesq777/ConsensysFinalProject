App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    // Load initial users (type is Admin and Owner).
    $.getJSON('../initusers.json', function(data) {
      for (i = 0; i < data.length; i ++) {
        // pick out user fields and add them into the user array
      }
    });
    return App.initWeb3();
  },

  initWeb3: function() {
    /*
     * Replace me...
     */

    return App.initContract();
  },

  initContract: function() {
    /*
     * Replace me...
     */

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-adopt', App.handleAdopt);
  },

  markAdopted: function(adopters, account) {
    /*
     * Replace me...
     */
  },

  handleAdopt: function(event) {
    event.preventDefault();

    var petId = parseInt($(event.target).data('id'));

    /*
     * Replace me...
     */
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
