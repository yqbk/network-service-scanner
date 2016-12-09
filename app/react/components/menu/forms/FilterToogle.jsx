import React, { Component } from 'react';
import Toggle from 'material-ui/Toggle';

const styles = {
    block: {
        maxWidth: 250,
    },
    toggle: {
        marginBottom: 16,
    },
    thumbOff: {
        backgroundColor: '#ffcccc',
    },
    trackOff: {
        backgroundColor: '#ff9d9d',
    },
    thumbSwitched: {
        backgroundColor: 'red',
    },
    trackSwitched: {
        backgroundColor: '#ff9d9d',
    },
    labelStyle: {
        color: 'red',
    },
};

class FilterToogle extends Component {

    constructor(props) {
        super(props)

        this.state = {
            filterDown: false,
            filterFiltered: false
        }
    }


    render() {

        return (
            <div style={{alignItems: 'center', maxWidth: 180, display: 'flex', height: 50}}>
                <Toggle
                    label="Show down hosts"
                    defaultToggled={true}
                    style={styles.toggle}
                    onToggle={this.props.filterDownHosts}
                />
                <Toggle
                    label="Show filtered hosts"
                    defaultToggled={true}
                    style={styles.toggle}
                    onToggle={this.props.filterFilteredHosts}
                />
            </div>
        )
    }
}

export default FilterToogle;