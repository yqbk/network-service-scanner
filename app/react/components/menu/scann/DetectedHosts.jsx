import React, { Component } from 'react'

import {Table, TableBody, TableHeader, TableHeaderColumn, TableRow, TableRowColumn} from 'material-ui/Table';

import RaisedButton from 'material-ui/RaisedButton';

import FlatButton from 'material-ui/FlatButton';


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
                            {/*<TableHeaderColumn>Service</TableHeaderColumn>*/}
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
                                {/*<TableRowColumn>{host.service}</TableRowColumn>*/}
                                <TableRowColumn>
                                    {/*<RaisedButton label="Delete"*/}
                                                  {/*primary={true}*/}
                                                  {/*onTouchTap={console.log("lala")}*/}
                                    {/*/>*/}
                                    {/*<FlatButton label="Save"*/}
                                                  {/*secondary={true}*/}
                                                  {/*onTouchTap={console.log("ok")}*/}
                                    {/*/>*/}
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





