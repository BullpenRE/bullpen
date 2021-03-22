$(document).on('turbolinks:load', () => {
  const formatNumber = (n) => {
    // format number 1000000 to 1,234,567
    return n.replace(/\D/g, "").replace(/\B(?=(\d{3})+(?!\d))/g, ",")
  }

  window.formatCurrency = function(input) {
    // appends $ to value
    // and puts cursor back in right position.

    // get input value
    let input_val = input.val();

    // don't validate empty input
    if (input_val === "") {
      return;
    }

    // original length
    const original_len = input_val.length;

    // initial caret position
    let caret_pos = input.prop("selectionStart");

    // no decimal entered
    // add commas to number
    // remove all non-digits
    input_val = formatNumber(input_val);
    input_val = "$" + input_val;

    // send updated string to input
    input.val(input_val);

    // put caret back in the right position
    const updated_len = input_val.length;
    caret_pos = updated_len - original_len + caret_pos;
    input[0].setSelectionRange(caret_pos, caret_pos);
  }
});
