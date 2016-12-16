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
            console.log(result)
        })
    }


    render () {

        return (
            <div>
                <RaisedButton label="Simple Scann"
                              primary={true}
                              onTouchTap={() => { this.performSimpleScann() }}
                />
                <table className="table table-bordered">
                    <thead>
                    <tr>
                        <td>IP</td>
                        <td>Port</td>
                        <td>Status</td>
                        <td>Time</td>
                        <td>Method</td>
                        <td>Service</td>
                        <td>Actions</td>
                    </tr>
                    </thead>
                    <tbody>

                    {this.props.hosts.map(host =>
                        <tr>
                            <td>{host.IP}</td>
                            <td>{host.port}</td>
                            <td>{host.status}</td>
                            <td>{host.scann_time}</td>
                            <td>{host.scann_type}</td>
                            <td>{host.service}</td>
                            <td>
                                <a className="btn btn-info">Detect service</a>
                                <a className="btn btn-danger">delete</a>
                            </td>
                        </tr>
                    )}

                    </tbody>
                </table>
            </div>
        )
    }
}

export default SecondTab