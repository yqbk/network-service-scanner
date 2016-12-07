import React, { Component } from 'react'

import {Table, TableBody, TableHeader, TableHeaderColumn, TableRow, TableRowColumn} from 'material-ui/Table';

class DetectedHosts extends Component {

    constructor () {
        super()
    }

    // componentWillReceiveProps(nextProps) {
    //
    //     console.log(" received prop ")
    //
    //     this.setState({ hostTable: nextProps.hostTable });
    //
    // }

    render () {

        const hostTable = this.props.hostTable

        return (
            <div>
                <Table>
                    <TableHeader displaySelectAll={false}
                                 adjustForCheckbox={false}>
                        <TableRow>
                            <TableHeaderColumn>IP</TableHeaderColumn>
                            <TableHeaderColumn>Port</TableHeaderColumn>
                            <TableHeaderColumn>Status</TableHeaderColumn>
                            <TableHeaderColumn>Time</TableHeaderColumn>
                            <TableHeaderColumn>Method</TableHeaderColumn>
                            <TableHeaderColumn>Service</TableHeaderColumn>
                            <TableHeaderColumn>Actions</TableHeaderColumn>
                        </TableRow>
                    </TableHeader>
                    <TableBody displayRowCheckbox={false}>

                        {hostTable ? hostTable.map((host, index) =>
                            <TableRow key={`TableRow-${index}`}>
                                <TableRowColumn>{host.IP}</TableRowColumn>
                                <TableRowColumn>{host.port}</TableRowColumn>
                                <TableRowColumn>{host.status}</TableRowColumn>
                                <TableRowColumn>{host.scann_time}</TableRowColumn>
                                <TableRowColumn>{host.scann_type}</TableRowColumn>
                                <TableRowColumn>{host.service}</TableRowColumn>
                                <TableRowColumn>
                                    <a className="btn btn-success">Save</a>
                                    <a className="btn btn-danger" onClick={console.log("lala")}>Delete</a>
                                </TableRowColumn>
                            </TableRow>
                        ) : null }

                    </TableBody>
                </Table>
            </div>
        )
    }
}

export default DetectedHosts





