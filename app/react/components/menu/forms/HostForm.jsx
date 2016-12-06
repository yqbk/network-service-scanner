import React from 'react';
// import { post } from '../utils';
import AutocompleteChips from './autocompleteChips';

class HostForm extends React.Component
{
    constructor (props) {
        super(props)

        this.methods = ['syn', 'fin', 'icmp']
        this.handleChange = this.handleChange.bind(this)
        this.handleSubmit = this.handleSubmit.bind(this)

        this.state = {
            ip: '',
            port: '',
            scann_type: [],
            submitButtonEnabled: false
        }
    }

    handleChange (e) {

        const { ip, port } = this.state
        const name = e.target ? e.target.name : e.name;
        const value = e.currentTarget ? e.currentTarget.value : e.value;

        this.setState({
            [name]: value,
            submitButtonEnabled: !!ip && !!port
        })
    }

    handleSubmit(e) {

        e.preventDefault()

        const { ip, port , scann_type} = this.state

        // todo refactor 1

        let inside = (arg) => { this.props.addHostToTable(arg)}

        scann_type.forEach(
            (method) => $.post('http://localhost:3000/hosts', {host: {IP: ip, port, scann_type: method}}, function(result){
                inside(result)
            })
        )

        // post('http://localhost:3000/hosts', {host: {ip, port}})
        //     .then((response) => {
        //         console.log(response)
        //     })
        //     .catch((error) => {
        //         // Who cares?
        //     })
    }

    render() {

        const { submitButtonEnabled, scann_type } = this.state
        const dataSource = this.methods.filter(method => !scann_type.includes(method))

        return (
            <form className="form-inline" onSubmit={this.handleSubmit} style={{ display: 'flex', alignItems: 'center', justifyContent: 'flex-end', height: 50 }}>
                <div className="form-group">
                    <input type="text"
                           className="form-control"
                           placeholder="ip address"
                           name="ip"
                           onChange={this.handleChange}
                    />
                </div>
                <div className="form-group" style={{ margin: '0 5px' }}>
                    <input type="number"
                           className="form-control"
                           placeholder="port"
                           name="port"
                           onChange={this.handleChange}
                    />
                </div>
                <div style={{ ...(dataSource.length > 0 ? { flex: 1 } : {}) }}>
                    <AutocompleteChips value={scann_type} onChange={this.handleChange} dataSource={dataSource} methods={this.methods} />
                </div>
                <button type="submit"
                        className="btn btn-primary"
                        disabled={!submitButtonEnabled}
                        style={{ marginLeft: 5, ...(dataSource.length > 0 ? { width: 200 } : { flex: 1 }) }}
                >
                    Go!
            </button>

            </form>
        )
    };
};

export default HostForm



