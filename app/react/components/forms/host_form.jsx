import React from 'react';
import Chip from 'material-ui/Chip';



const HostForm = (props) => {

    // getInitialState() {
    //     IP = '';
    //     port = '';
    // }
    //
    // valid() {
    //     state.IP && state.port
    // }
    //
    // handleChange(e) {
    //     //noinspection JSAnnotator
    //     name = e.target.name;
    //     this.setState({name: e.target.value})
    // }
    //
    // handleSubmit(e) {
    //     // e.preventDefault()
    //     // $.post '', { host: @state }, (data) =>
    //     // @props.handleNewHost data
    //     // @setState @getInitialState()
    //     // , 'JSON'
    // }

    return (
        <form className="form-inline" >
            <div className="form-group">
                <input type="text"
                       className="form-control"
                       placeholder="ip address"
                       name="IP"/>
            </div>
            <div className="form-group">
                <input type="number"
                       className="form-control"
                       placeholder="port"
                       name="port"/>
            </div>
            <div className="form-group">
                <input type="number"
                       className="form-control"
                       placeholder="port"
                       name="port"/>
            </div>
            <button type="submit"
                    className="btn btn-primary">
                Go!
            </button>

        </form>
    )
};

export default HostForm



