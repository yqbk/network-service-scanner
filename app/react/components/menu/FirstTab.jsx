import React, { Component } from 'react'

import HostForm from './forms/HostForm'

import DetectedHosts from './scann/DetectedHosts';

class FirstTab extends Component {

    constructor () {
        super()

        this.addHostToTable = this.addHostToTable.bind(this)

        this.state = {
            hostTable: []
        }

    }

    addHostToTable (host) {
        // this.hostTable.push("llala")

        const tablica  = this.state.hostTable

        this.setState({
            hostTable: [...tablica, host]
        })

    }


    render () {

        console.log("in firstTab: " + this.state)

        return (
            <div>
                <HostForm addHostToTable = {this.addHostToTable} />
                <DetectedHosts hostTable = {this.state.hostTable} />
            </div>
        )
    }

}

export default FirstTab