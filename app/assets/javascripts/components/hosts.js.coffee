@Hosts = React.createClass
  getInitialState: ->
    hosts: @props.data

  getDefaultProps: ->
    hosts: []

  addHost: (host) ->
    hosts = React.addons.update(@state.hosts, { $push: [host] })
    @setState hosts: hosts

  deleteHost: (host) ->
    index = @state.hosts.indexOf host
    hosts = React.addons.update(@state.hosts, { $splice: [[index, 1]] })
    @replaceState hosts: hosts


  render: ->
    React.DOM.div
      className: 'hosts'
      React.DOM.h2
        className: 'title'
        'Detected IP addresses'
      React.createElement HostForm, handleNewHost: @addHost
      React.DOM.hr null
      React.DOM.table
        className: 'table table-bordered'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'IP'
            React.DOM.th null, 'port'
            React.DOM.th null, 'status'
            React.DOM.th null, 'Actions'
        React.DOM.tbody null,
          for host in @state.hosts
            React.createElement Host, key: host.id, host: host #, handleDeleteHost @deleteHost