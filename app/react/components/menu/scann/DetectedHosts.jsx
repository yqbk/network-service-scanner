import React, { Component } from 'react'

import {Table, TableBody, TableHeader, TableHeaderColumn, TableRow, TableRowColumn} from 'material-ui/Table';

import RaisedButton from 'material-ui/RaisedButton';

import FlatButton from 'material-ui/FlatButton';

import FilterToogle from '../forms/FilterToogle'


class DetectedHosts extends Component {

    constructor () {
        super()

        this.filterDownHosts = this.filterDownHosts.bind(this)
        this.filterFilteredHosts = this.filterFilteredHosts.bind(this)

        this.state = {
            filterDown: false,
            filterFiltered: false
        }
    }

    filterDownHosts (){
        this.setState({filterDown: !this.state.filterDown})
    }

    filterFilteredHosts (){
        this.setState({filterFiltered: !this.state.filterFiltered})
    }


    // todo unfiltered and others
    filterTable(table)
    {
        const filtered = table.reduce( (newTable, element) => {
            const reducedDown =  (element.status === 'up' || element.status === 'filtered' ) ?
                [...newTable, element] :
                (this.state.filterDown === (element.status === 'down')) ? newTable : [...newTable, element]

            return reducedDown.reduce( (newTable, element) => {
                return  (element.status === 'up' || element.status === 'down' ) ?
                    [...newTable, element] :
                    (this.state.filterFiltered === (element.status === 'filtered')) ? newTable : [...newTable, element]
            }, [])
        }, [])

        return filtered
    }

    render () {

        const hostTable = this.filterTable( this.props.hostTable)

        return (
            <div>
                <FilterToogle filterDownHosts={this.filterDownHosts} filterFilteredHosts={this.filterFilteredHosts}/>

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





