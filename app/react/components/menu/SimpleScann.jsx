import React, { Component } from 'react'
import DetectedHosts from './scann/DetectedHostsInSimpleScann';
import ProgressBar from './forms/progressBar'
import Graph from '../libs/index'
import RaisedButton from 'material-ui/RaisedButton';
import ip from 'ip';

import _ from 'lodash'


class FirstTab extends Component {

    constructor () {
        super()

        this.addHostToTable = this.addHostToTable.bind(this)
        this.setScannAmount = this.setScannAmount.bind(this)

        this.state = {
            hostTable: [],
            scannAmount: 0
        }
    }

    addHostToTable (host) {
        const tablica  = this.state.hostTable
        this.setState({
            hostTable: [...tablica, host]
        })
    }

    // todo zgodnie z konswencją?
    setScannAmount (amount) {
        this.setState({
            scannAmount: amount,
            hostTable: []
        })
    }

    localIP(callback){

        //todo marek callback???

        var myIp = 0
        window.RTCPeerConnection = window.RTCPeerConnection || window.mozRTCPeerConnection || window.webkitRTCPeerConnection;   //compatibility for firefox and chrome
        var pc = new RTCPeerConnection({iceServers:[]}), noop = function(){};
        pc.createDataChannel("");    //create a bogus data channel
        pc.createOffer(pc.setLocalDescription.bind(pc), noop);    // create offer and set local description
        pc.onicecandidate = function(ice){  //listen for candidate events
            if(!ice || !ice.candidate || !ice.candidate.candidate)  return;
            const IP = /([0-9]{1,3}(\.[0-9]{1,3}){3}|[a-f0-9]{1,4}(:[a-f0-9]{1,4}){7})/.exec(ice.candidate.candidate)[1];
            if(callback) callback(IP);
            pc.onicecandidate = noop;
        };

    }


    getActiveHosts(){

        const parts = ip.mask('192.168.0.1', '255.255.255.0').split(".")
        const network = parts[0] + "." + parts[1] + "." +  parts[2] + "."
        const hosts = _.range(1,254).reduce( (table, val) => {
            return [...table, network + val]
        },[])

        //todo whole range not only few selected
        // return ['192.168.88.6','192.168.88.14']
        return hosts
        // return ['192.168.0.1','192.168.0.9','192.168.0.11','192.168.0.27','192.168.0.52','192.168.0.6']
    }

    performSimpleScann (){

        const hosts = this.getActiveHosts()
        const tcp_ports = [21,22,23,24,25,53,80,443,1723,3000,3389,4567,8080]
        const udp_ports = [53,111,123,137,161]

        this.setScannAmount(tcp_ports.length * hosts.length)
        console.log(this.state.scannAmount)

        // todo marek render after finished not in loop execution
        // todo add udp scann to simple scann?
        //todo check with fin scann one more time?

        hosts.forEach( (host) =>
        {
            // tcp_ports.forEach( (port) =>
            // {

                $.post('http://localhost:3000/hosts', {host: {IP: host, port: 22, scann_type: 'ping'}}, (result) => {
                    result.status == 'up' ? this.addHostToTable(result) : null
                    // resultAck.status == 'filtered' ? null : $.post('http://localhost:3000/hosts', {host: {IP: host, port: port, scann_type: 'syn'}}, (resultSyn) => {
                    //     resultSyn.status != 'down' ? this.addHostToTable(resultSyn) :
                    //         // $.post('http://localhost:3000/hosts', {host: {IP: host, port: port, scann_type: 'fin'}}, (resultFin) => {
                    //         // resultFin.status != 'down' ? this.addHostToTable(resultFin):
                    //             null
                    //     // })
                    // })
                })
            // })
        })
    }

    render () {

        const hostNodes = this.state.hostTable.map( (host, index) => {
            return {id: index, label: host.IP}
            })

        const hostEdges = this.state.hostTable.reduce( (result, host, index ) => {
            const edges =  this.state.hostTable.reduce( (table, element, id) => {
                return index < id ? [...table, {from: id, to: index}] : table
            }, [])
            return [...result, edges]
        }, [])


        const data = {
            nodes: hostNodes,
            edges: [].concat.apply([], hostEdges)
        };

        return (
            <div>
                <RaisedButton label="Simple Scann"
                              primary={true}
                              onTouchTap={() => { this.performSimpleScann() }}
                />
                <hr/>
                {/*<ProgressBar scannAmount = {this.state.scannAmount} hostTableLenght = {this.state.hostTable.length}/>*/}
                {/*<hr/>*/}
                <DetectedHosts hostTable = {this.state.hostTable} deleteHost = {this.deleteHost} />
                <Graph graph={data}/>
            </div>
        )
    }
}

export default FirstTab