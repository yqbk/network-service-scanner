import React, { Component } from 'react'
import DetectedHosts from './scann/DetectedHosts';
import ProgressBar from './forms/progressBar'
import Graph from '../libs/index'
import RaisedButton from 'material-ui/RaisedButton';

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

        //todo marek? get active hosts

        // let hosts = []

        // $.post('http://localhost:3000/hosts', {host: {scann_type: 'getActiveHosts'}}, (result) => {
        //     hosts = result
        // })

        return ['192.168.88.6','192.168.88.14']

        // return ['192.168.88.19']
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
                })
            })
        })
    }

    render () {

        const hostNodes = this.state.hostTable.map( (host, index) => {
            return {id: index, label: host.IP + " : " + host.port }
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