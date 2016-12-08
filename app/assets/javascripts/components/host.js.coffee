@Host = React.createClass

  handleDelete: (e) ->
    e.preventDefault()
    $.ajax
      method: 'DELETE'
      url: "/hosts/#{ @props.host.id }"
      dataType: 'JSON'
      success: () =>
        @props.handleDeleteHost @props.host

  handleDetect: (e) ->
    e.preventDefault()
    $.ajax
#      method: 'DELETE'
#      url: "/hosts/#{ @props.host.id }"
#      dataType: 'JSON'
#      success: () =>
#        @props.handleDeleteHost @props.host

  render: ->
    React.DOM.tr null,
      React.DOM.td null, @props.host.IP
      React.DOM.td null, @props.host.port
      React.DOM.td null, @props.host.status
      React.DOM.td null, @props.host.scann_time
      React.DOM.td null, @props.host.scann_type
      React.DOM.td null, @props.host.service
      React.DOM.td null,
        React.DOM.a
          className: 'btn btn-info'
          onClick: @handleDetect
          'Detect service'
        React.DOM.a
          className: 'btn btn-warning'
          onClick: @handleDetect
          'Retry'
        React.DOM.a
          className: 'btn btn-danger'
          onClick: @handleDelete
          'Delete'


