import React, { Component } from 'react'

import HostForm from './forms/HostForm'

import DetectedHosts from './scann/DetectedHosts';

class FirstTab extends Component {

    constructor () {
        super()

        this.addHostToTable = this.addHostToTable.bind(this)


        //todo refactor 2
        this.state = {
            tablica: []
        }

        this.hostTable = this.state.tablica

    }

    addHostToTable (host) {
        // this.hostTable.push("llala")

        const { tablica } = this.state

        tablica.push(host)

    }


    render () {

        console.log("in firstTab: " + this.state)

        return (
            <div>
                <HostForm addHostToTable = {this.addHostToTable} />
                <DetectedHosts hostTable = {this.hostTable} />
            </div>
        )
    }

}

export default FirstTab