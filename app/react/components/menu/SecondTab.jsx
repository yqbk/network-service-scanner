import React, { Component } from 'react'


import RaisedButton from 'material-ui/RaisedButton';

import FlatButton from 'material-ui/FlatButton';


class SecondTab extends Component {

    constructor (props) {
        super(props)

        // this.addHostToTable = this.addHostToTable.bind(this)
        this.performSimpleScann = this.performSimpleScann.bind(this)
        this.formatDataTime = this.formatDataTime.bind(this)

        this.state = {
            hostTable: [],
            scannAmount: 0,
            scannDateTime: 0
        }
    }


    performSimpleScann (){

        this.state.scannDateTime = new Date()
        this.state.hostTable = this.props.hosts

        $.post('http://localhost:3000/hosts', {host: {scann_type: 'simple'}}, (result) => {
            console.log("przed " + this.state.hostTable.length)
            this.forceUpdate()
            console.log("po " + this.state.hostTable.length)
            // console.log(result)
        })



    }

    // todo marek ???
    componentWillReceiveProps(nextProps) {
        // You don't have to do this check first, but it can help prevent an unneeded render
        if (nextProps.hosts !== this.state.hostTable) {
            console.log("\n\nzmiana!!\n\n")
            this.setState({ hostTable: nextProps.hosts });
        }
    }

    formatDataTime(dataTime){
        let t = dataTime.split(/[- :T.]/);
        return new Date(Date.UTC(t[0], t[1]-1, t[2], t[3], t[4], t[5]));
    }



    render () {


        const simpleScannHosts = this.state.hostTable.reduce((newTable, element) =>
        {

            const createdDateTime = this.formatDataTime(element.created_at)

            console.log("\n\nnext element:\n")
            console.log(element.created_at)
            console.log(createdDateTime)
            console.log(this.state.scannDateTime)

            return this.state.scannDateTime <= createdDateTime ?  newTable : [...newTable, element]


        }, [])

        console.log(simpleScannHosts.length + " kontra " + this.state.hostTable.length)

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
                        <td>Date</td>
                        <td>Method</td>
                        <td>Service</td>
                        <td>Actions</td>
                    </tr>
                    </thead>
                    <tbody>

                    {simpleScannHosts.map( (host, index) =>
                        <tr key={`TableRow-${index}`}>
                            <td>{host.IP}</td>
                            <td>{host.port}</td>
                            <td>{host.status}</td>
                            <td>{host.created_at}</td>
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