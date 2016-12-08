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
      React.DOM.button
        type: 'submit'
        className: 'btn btn-primary'
        disabled: !@valid()
        'Scann network'

  handleChange: (e) ->
    name = e.target.name
    @setState "#{ name }": e.target.value

  valid: ->
    @state.IP

  handleSubmit: (e) ->
    e.preventDefault()
    $.post '', { host: @state }, (data) =>
      @props.handleNewHost data
      @setState @getInitialState()
    , 'JSON'


