@Hosts = React.createClass
  getInitialState: ->
    hosts: @props.data

  getDefaultProps: ->
    hosts: []

#  credits: ->
#    credits = @state.hosts.filter (val) -> val.amount >= 0
#    credits.reduce ((prev, curr) ->
#      prev + parseFloat(curr.amount)
#    ), 0
#
#  debits: ->
#    debits = @state.hosts.filter (val) -> val.amount < 0
#    debits.reduce ((prev, curr) ->
#      prev + parseFloat(curr.amount)
#    ), 0

#  balance: ->
#    @debits() + @credits()

  addRecord: (record) ->
    hosts = React.addons.update(@state.hosts, { $push: [record] })
    @setState hosts: hosts

  deleteRecord: (record) ->
    index = @state.hosts.indexOf record
    hosts = React.addons.update(@state.hosts, { $splice: [[index, 1]] })
    @replaceState hosts: hosts

  updateRecord: (record, data) ->
    index = @state.hosts.indexOf record
    hosts = React.addons.update(@state.hosts, { $splice: [[index, 1, data]] })
    @replaceState hosts: hosts

  render: ->
    React.DOM.div
      className: 'hosts'
      React.DOM.h2
        className: 'title'
        'Detected IP addresses'
      React.createElement ScannForm
      React.DOM.hr null
      React.DOM.table
        className: 'table table-bordered'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'IP'
            React.DOM.th null, 'Time'
        React.DOM.tbody null,
          for host in @state.hosts
            React.createElement Host, key: host.id, host: host
