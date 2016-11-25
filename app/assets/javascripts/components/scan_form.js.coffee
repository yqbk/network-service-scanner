@ScannForm = React.createClass
  getInitialState: ->
    title: ''
    date: ''
    amount: ''
  render: ->
    React.DOM.form
      className: 'form-inline'
#      onSubmit: @handleSubmit
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'Title'
          name: 'title'
          value: @state.title
#          onChange: @handleChange
      React.DOM.button
        type: 'submit'
        className: 'btn btn-primary'
#        disabled: !@valid()
        'Scann network'

#  handleChange: (e) ->
#    name = e.target.name
#    @setState "#{ name }": e.target.value
#
#  valid: ->
#    @state.title && @state.date && @state.amount

#  handleSubmit: (e) ->
#    e.preventDefault()
#    $.post '', { record: @state }, (data) =>
#      @props.handleNewRecord data
#      @setState @getInitialState()
#    , 'JSON'
