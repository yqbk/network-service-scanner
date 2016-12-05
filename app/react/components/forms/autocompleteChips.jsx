import React, { Component } from 'react'

import AutoComplete from 'material-ui/AutoComplete';
import Chip from 'material-ui/Chip';

class AutocompleteChips extends Component {
    constructor () {
        super()

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
        const { value, onChange, methods } = this.props
        const newValues = methods.includes(newChip) ? [...value, newChip] : null
        if (newValues) {
            onChange({
                name: 'scann_type',
                value: newValues
            })
        }
        this.setState({
            errorText: newValues ? '' : `Method "${newChip}" does not exist`
        })
        this.refs.autoComplete && this.refs.autoComplete.setState({ searchText: '' })
    }



    render () {
        const { value, dataSource } = this.props
        const { errorText } = this.state
        return (
            <div style={{ display: 'flex', alignItems: 'baseline' }}>
                <div style={{ display: 'flex', alignItems: 'baseline' }}>
                    {
                        value.map((item, chipIndex) => (
                            <Chip
                                key={`chip-${chipIndex}`}
                                style={{ marginRight: 10 }}
                                onRequestDelete={() => this.handleDeleteChip(chipIndex)}
                            >
                                {item}
                            </Chip>
                        ))
                    }
                </div>
                {
                    dataSource.length > 0
                        ?
                            <AutoComplete
                                ref="autoComplete"
                                hintText="Choose scann method"
                                dataSource={dataSource}
                                onNewRequest={this.handleNewChips}
                                filter={(searchText, key) => searchText === '' || key.indexOf(searchText) !== -1}
                                errorText={errorText}
                                openOnFocus
                                fullWidth
                            />

                        : null
                }

            </div>
        )
    }
}

export default AutocompleteChips
