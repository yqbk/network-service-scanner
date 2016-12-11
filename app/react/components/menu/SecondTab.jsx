import React, { Component } from 'react'


import RaisedButton from 'material-ui/RaisedButton';

import FlatButton from 'material-ui/FlatButton';


class SecondTab extends Component {

    constructor () {
        super()

        this.addHostToTable = this.addHostToTable.bind(this)
        this.performSimpleScann = this.performSimpleScann.bind(this)

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


    performSimpleScann (){
        $.post('http://localhost:3000/hosts', {host: {scann_type: 'simple'}}, (result) => {
            this.props.addHostToTable(result)
        })
    }


    render () {

        return (
            <div>
                <RaisedButton label="Simple Scann"
                              primary={true}
                              onTouchTap={() => { this.performSimpleScann() }}
                />
            </div>
        )
    }
}

export default SecondTab