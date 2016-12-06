import React, { Component } from 'react'

import HostForm from './forms/HostForm'

import DetectedHosts from './scann/DetectedHosts';

class FirstTab extends Component {

    constructor () {
        super()

        this.addHostToTable = this.addHostToTable.bind(this)


        //todo refactor 2
        this.state = {
            hostTable: []
        }

    }

    addHostToTable (host) {
        // this.hostTable.push("llala")

        const tablica  = this.state.hostTable

        tablica.push(host)

        this.setState({hostTable: tablica})

        console.log("after push: " + this.state.hostTable)

    }


    render () {

        console.log("in firstTab: " + this.state.hostTable)

        return (
            <div>
                <HostForm addHostToTable = {this.addHostToTable} />
                <DetectedHosts hostTable = {this.state.hostTable} />
            </div>
        )
    }

}

export default FirstTab