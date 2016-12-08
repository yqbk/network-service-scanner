// import React from 'react';
//
// class Hosts extends React.Component {
//
//
//
//     var Table = React.createClass({
//
//     getInitialState: function() {
//
//         var hosts = this.props.hosts
//
//         var tabledata = [];
//         var length = _.size(testJSON.zones);
//
//         for(i = 0; i < length; i++) {
//
//             var name = _.keys(testJSON.zones)[i];
//
//             var population = testJSON.zones[name].population.value;
//             if(name == "default") {
//                 population = testJSON.zones[name].population.default.value;
//             }
//
//             tabledata[i] = {name, population};
//         }
//         console.log(tabledata);
//         return {zones: tabledata};
//     },
//
//     render: function() {
//         var rows = [];
//         this.state.zones.forEach(function(zone) {
//             rows.push(<tr Population={zone.population} Zone={zone.name} />);
//         }.bind(this));
//         console.log(rows);
//         return (
//             <table>
//                 <thead>
//                 <tr>
//                     <th>Zone</th>
//                     <th>Population</th>
//                 </tr>
//                 </thead>
//                 <tbody>{rows}</tbody>
//             </table>
//         );
//     }
// });
//
//
//
//
//
//
//
//     render() {
//         return(
//             <div className="hosts">
//                 <h2 className="title" >
//                     Detected IP addresses
//                     <hr/>
//                     {/*form for hosts*/}
//                     <hr/>
//                     <table className="table table-bordered">
//                         <thead>
//                             <tr></tr>
//                             <th>ip</th>
//                             <th>port</th>
//                             <th>status</th>
//                             <th>time</th>
//                             <th>method</th>
//                             <th>service</th>
//                             <th>actions</th>
//                         </thead>
//                         <tbody>
//                             for
//                         </tbody>
//                     </table>
//                 </h2>
//             </div>
//         );
//     }
//
//     getInitialProps() {
//         hosts = @props.data
//     };
//
//     getInitialProps() {
//         hosts =  []
//     };
//
//
//     // addHost(host) {
//     //     hosts = React.addons.update(@state.hosts, { $push: [host] })
//     //     @setState hosts: hosts
//     // };
//
//
//
// }
//
// export default HelloWorld;
//
//
//
//
// render: ->
// React.DOM.div
// className: 'hosts'
// React.DOM.h2
// className: 'title'
// 'Detected IP addresses'
// React.createElement HostForm, handleNewHost: @addHost
// React.DOM.hr null
// React.DOM.table
// className: 'table table-bordered'
// React.DOM.thead null,
//     React.DOM.tr null,
//     React.DOM.th null, 'IP'
// React.DOM.th null, 'Port'
// React.DOM.th null, 'Status'
// React.DOM.th null, 'Time'
// React.DOM.th null, 'Method'
// React.DOM.th null, 'Service'
// React.DOM.th null, 'Actions'
// React.DOM.tbody null,
// for host in @state.hosts
//     React.createElement Host, key: host.id, host: host #, handleDeleteHost @deleteHost
