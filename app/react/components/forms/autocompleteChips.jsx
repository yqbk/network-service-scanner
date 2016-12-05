import React, { Component } from 'react'

import AutoComplete from 'material-ui/AutoComplete';
import Chip from 'material-ui/Chip';

class AutocompleteChips extends Component {
    constructor () {
        super()

        this.methods = ['syn', 'fin', 'icmp']
        this.handleNewChips = this.handleNewChips.bind(this)
        this.handleDeleteChip = this.handleDeleteChip.bind(this)

        this.state = {
            errorText: ''
        }
    }

    handleDeleteChip (chipIndex)
    {
        const { value, onChange } = this.props
        const newValues = value.slice(0, chipIndex).concat(value.slice(chipIndex+1))

        onChange({
            name: 'scann_type',
            value: newValues
        })

    }

    handleNewChips (newChip) {
        const { value, onChange } = this.props
        const newValues = this.methods.includes(newChip) ? [...value, newChip] : null
        if (newValues) {
            onChange({
                name: 'scann_type',
                value: newValues
            })
        }
        this.setState({
            errorText: newValues ? '' : `Method "${newChip}" does not exist`
        })
        this.refs.autoComplete.setState({ searchText: '' })
    }

    render () {
        const { value } = this.props
        const { errorText } = this.state
        return (
            <div>
                <div>
                    {
                        value.map((item, chipIndex) => (
                            <Chip onRequestDelete={() => this.handleDeleteChip(chipIndex)}>{item}</Chip>
                        ))
                    }
                </div>
                <AutoComplete
                    ref="autoComplete"
                    dataSource={this.methods.filter(method => !value.includes(method))}
                    onNewRequest={this.handleNewChips}
                    filter={(searchText, key) => searchText === '' || key.indexOf(searchText) !== -1}
                    errorText={errorText}
                    openOnFocus
                />
            </div>
        )
    }
}

export default AutocompleteChips
