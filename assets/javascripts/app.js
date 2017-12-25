
$('#datatable').DataTable({
  columnDefs: [
    {orderable: false, targets: 0}
  ],
  order: [[5, 'desc']]
});

var initialValueFor = function(obj) {
  return obj.data('handle') == 'left' ? 0 : 100
}

var arrangeHandles = function(obj) {
  obj.each(function(idx, handle) {
    attr = idx == 0 ? 'left' : 'right'
    $(handle).data('handle', attr)
  })
}

var displayRange = function(obj, ui) {
  handles = {left: null, right: null}
  obj.each(function(idx, el) {
    $el = $(el)
    val = ui.values ? ui.values[idx] : initialValueFor($el)
    handles[$el.data('handle')] = val
  })
  range = $el.parent().prev()
  range.find('.left-handle').html(handles['left'] + '%').css($el.position())
  range.find('.right-handle').html(handles['right'] + '%').css($el.position())
}

var updateSliderValue = function(event, ui) {
  handles = $(this).find('.ui-slider-handle')
  arrangeHandles(handles)
  displayRange(handles, ui)
}

$('.slider').each(function(idx, el){
  $el = $(el);
  $el.slider({
    animate: 'fast',
    range: true,
    values: [0, 100],
    min: 0,
    max: 100,
    slide: updateSliderValue,
    create: updateSliderValue
  })
})

$('.menu-btn').click(function() {
  $(this).toggleClass("menu-btn-left");
  var panel = $('.box-out');

  panel.toggleClass('box-in')
  if (panel.hasClass('box-in')) {
    $('.inner-container').animate({width: '90%'}, 600)
  } else {
    $('.inner-container').animate({width: '65%'}, 400)
  }
})

var valueRangePercent = function(min, max, percent) {
  return (percent * (max - min) / 100) + min
}

$('.slider').on('slide', function(event, ui) {
  _ui    = ui
  $this  = $(this)
  column = $this.parent().data('column')
  table  = $('#datatable').DataTable()

  $.fn.dataTable.ext.search.push(
    function(settings, data, dataIndex) {
      var min = Number($this.prev().data('min'))
      var max = Number($this.prev().data('max'))
      var min_percent = _ui.values[0]
      var max_percent = _ui.values[1]
      var price = parseFloat(data[column].replace(/,/g, '')) || 0
      var min_vrp = valueRangePercent(min, max, min_percent)
      var max_vrp = valueRangePercent(min, max, max_percent)

      if (price >= min_vrp && price <= max_vrp) { return true }
      return false
    }
  )

  table.draw()
})
