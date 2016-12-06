import React, { Component } from 'react'

import HostForm from './forms/HostForm'

import DetectedHosts from './scann/DetectedHosts';

class FirstTab extends Component {

    constructor () {
        super()

        this.hostTable = []
    }

    render () {

        return (
            <div>
                <HostForm hostTable = {this.hostTable}/>
                <DetectedHosts hostTable = {this.hostTable} />
            </div>
        )
    }

}

export default FirstTab