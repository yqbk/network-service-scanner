import React from 'react';
import Chip from 'material-ui/Chip';



class HostForm extends React.Component
{
    constructor () {
        super()

        this.handleChange = this.handleChange.bind(this)

        this.state = {
            ip: '',
            port: '',
            submitButtonEnabled: false
        }
    }

    handleChange (e) {
        const { ip, port } = this.state
        const name = e.target.name;
        const value = e.currentTarget.value;
        this.setState({
            [name]: value,
            submitButtonEnabled: !!ip && !!port
        })
    }


    //
    // handleSubmit(e) {
    //     // e.preventDefault()
    //     // $.post '', { host: @state }, (data) =>
    //     // @props.handleNewHost data
    //     // @setState @getInitialState()
    //     // , 'JSON'
    // }

    render() {
        const { submitButtonEnabled } = this.state
        console.log(this.state)
        return (
            <form className="form-inline">
                <div className="form-group">
                    <input type="text"
                           className="form-control"
                           placeholder="ip address"
                           name="ip"
                           onChange={this.handleChange}
                    />
                </div>
                <div className="form-group">
                    <input type="number"
                           className="form-control"
                           placeholder="port"
                           name="port"
                           onChange={this.handleChange}
                    />
                </div>

                <button type="submit"
                        className="btn btn-primary"
                        disabled={!submitButtonEnabled}
                >
                    Go!
                </button>

            </form>
        )
    };
};

export default HostForm


