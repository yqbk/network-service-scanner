import React, { Component } from 'react'
import HostForm from './forms/HostForm'
import DetectedHosts from './scann/DetectedHosts';
import ProgressBar from './forms/progressBar'
import Graph from '../libs/index'
import { LineChart, PieChart } from 'react-chartkick';

import RaisedButton from 'material-ui/RaisedButton';
import MyMuiDataTable from './forms/MuiDataTable'

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

    getActiveHosts(){
        let hosts = []

        $.post('http://localhost:3000/hosts', {host: {scann_type: 'getActiveHosts'}}, (result) => {
            hosts = result
        })

        return ['192.168.88.1','192.168.88.6', '192.168.88.12','192.168.88.14', '192.168.88.15']

        // return ['192.168.88.19']
    }



    performSimpleScann (){

        const hosts = this.getActiveHosts()
        const tcp_ports = [21,22,23,24,25,53,80,443,1723,3000,3389,4567,8080]
        const udp_ports = [53,111,123,137,161]

        this.setScannAmount(tcp_ports.length * hosts.length)
        console.log(this.state.scannAmount)

        // todo marek render after finished not in loop execution

        hosts.forEach( (host) =>
        {
            tcp_ports.forEach( (port) =>
            {
                $.post('http://localhost:3000/hosts', {host: {IP: host, port: port, scann_type: 'ack'}}, (resultAck) => {

                    resultAck.status == 'filtered' ? null : $.post('http://localhost:3000/hosts', {host: {IP: host, port: port, scann_type: 'syn'}}, (resultSyn) => {
                        resultSyn.status != 'down' ? this.addHostToTable(resultSyn) :
                            // $.post('http://localhost:3000/hosts', {host: {IP: host, port: port, scann_type: 'fin'}}, (resultFin) => {
                            // resultFin.status != 'down' ? this.addHostToTable(resultFin):
                                null
                        // })
                    })

                        //todo check with fin scann one more time?

                        // console.log(this.state.hostTable)
                    })
                })
            })
        }



    render () {

        const hostNodes = this.state.hostTable.map( (host, index) => {
            return {id: index, label: host.IP}
            })

        const hostEdges = this.state.hostTable.map( (host, index) => {
            return index !== 0 ? {from: 0, to: index} : {}
        })

        var data = {
            nodes: hostNodes,
            edges: hostEdges
        };

        return (
            <div>
                <RaisedButton label="Simple Scann"
                              primary={true}
                              onTouchTap={() => { this.performSimpleScann() }}
                />
                <hr/>
                <ProgressBar scannAmount = {this.state.scannAmount} hostTableLenght = {this.state.hostTable.length}/>
                <hr/>
                <DetectedHosts hostTable = {this.state.hostTable} deleteHost = {this.deleteHost} />
                <Graph graph={data}/>
            </div>
        )
    }
}

export default FirstTab