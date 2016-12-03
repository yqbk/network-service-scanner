@HostForm = React.createClass
  getInitialState: ->
    IP: ''
  render: ->
    React.DOM.form
      className: 'form-inline'
      onSubmit: @handleSubmit
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'ip address'
          name: 'IP'
          value: @state.IP
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'number'
          className: 'form-control'
          placeholder: 'port number'
          name: 'port'
          value: @state.port
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'Scann type'
          name: 'scann_type'
          value: @state.scann_type
          onChange: @handleChange
#          'Scann network'
#        React.DOM.div
#          className: 'form-group'
#          React.DOM.input
#            type: 'radio'
#            className: 'form-control'
#            placeholder: 'Method'
#            name: 'method2'
#            value: 'method2'
#            onChange: @handleChange
##            'Scann network'
      React.DOM.button
        type: 'submit'
        className: 'btn btn-primary'
        disabled: !@valid()
        'Scann network'

  handleChange: (e) ->
    name = e.target.name
    @setState "#{ name }": e.target.value

  valid: ->
    @state.scann_type
#    @state.IP && @state.port

  handleSubmit: (e) ->
    e.preventDefault()
    $.post '', { host: @state }, (data) =>
      @props.handleNewHost data
      @setState @getInitialState()
    , 'JSON'


