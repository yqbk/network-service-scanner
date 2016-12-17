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

        return ['192.168.88.1','192.168.88.6', '192.168.88.12','192.168.88.14', '192.168.88.15','192.168.88.19']

        // return ['192.168.88.6']
    }



    performSimpleScann (){

        const hosts = this.getActiveHosts()
        const tcp_ports = [21,22,23,24,25,53,80,443,1723,3000,3389,4567,8080]
        const udp_ports = [53,111,123,137,161]

        hosts.forEach( (host) =>
        {
            tcp_ports.forEach( (port) =>
            {
                $.post('http://localhost:3000/hosts', {host: {IP: host, port: port, scann_type: 'ack'}}, (resultAck) => {

                    resultAck.status == 'filtered' ? null : $.post('http://localhost:3000/hosts', {host: {IP: host, port: port, scann_type: 'syn'}}, (resultSyn) => {
                        resultSyn.status != 'down' ? this.addHostToTable(resultSyn) : $.post('http://localhost:3000/hosts', {host: {IP: host, port: port, scann_type: 'fin'}}, (resultFin) => {
                            resultFin.status != 'down' ? this.addHostToTable(resultFin): null
                        })
                    })

                        //todo check with fin scann one more time?

                        console.log(this.state.hostTable)
                    })
                })
            })
        }

        // this.state.scannDateTime = new Date()
        // this.state.hostTable = this.props.hosts
        //
        // const addresses = this.getActiveHosts()
        //
        // $.post('http://localhost:3000/hosts', {host: {scann_type: 'simple'}}, (result) => {
        //     console.log("przed " + this.state.hostTable.length)
        //     this.forceUpdate()
        //     console.log("po " + this.state.hostTable.length)
        //     // console.log(result)
        //     // this.props.addHostToTable(result)
        // })



    render () {


        return (
            <div>
                <RaisedButton label="Simple Scann"
                              primary={true}
                              onTouchTap={() => { this.performSimpleScann() }}
                />
                {/*<HostForm addHostToTable = {this.addHostToTable} setScannAmount = {this.setScannAmount}/>*/}
                {/*<ProgressBar scannAmount = {this.state.scannAmount} hostTableLenght = {this.state.hostTable.length}/>*/}
                {/*<Graph graph={data}/>*/}
                {/*<LineChart data={{"2013-02-10 00:00:00 -0800": 11, "2013-02-11 00:00:00 -0800": 6}} />*/}
                <hr/>
                {/*<MyMuiDataTable hostTable = {this.state.hostTable}/>*/}
                <DetectedHosts hostTable = {this.state.hostTable} deleteHost = {this.deleteHost} />
            </div>
        )
    }
}

export default FirstTab