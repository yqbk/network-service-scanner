import _ from 'lodash'
import React from 'react';
import RaisedButton from 'material-ui/RaisedButton';
import AutocompleteChips from './autocompleteChips';

class HostForm extends React.Component
{
    constructor (props) {
        super(props)

        this.methods = ['ping', 'syn', 'fin', 'ack', 'udp' ]
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

        let ports = this.formatInput(port)

        let ipsArray = ip.split(".").map(this.formatInput)

        let ips = this.cartesianProductOf.apply(this, ipsArray)

        let ipsString = ips.map( (array) => {  return array.join(".") })

        this.props.setScannAmount(ports.length * ipsString.length * scann_type.length )

        ipsString.forEach( (singleAddress) => {
            ports.forEach( (singlePort) => {
                scann_type.forEach(
                    (method) => $.post('http://localhost:3000/hosts', {host: {IP: singleAddress, port: singlePort, scann_type: method}}, (result) => {
                        this.props.addHostToTable(result)
                    })
                )
            })
        })
    }

    cartesianProductOf() {
        return _.reduce(arguments, function(a, b) {
            return _.flatten(_.map(a, function(x) {
                return _.map(b, function(y) {
                    return x.concat([y]);
                });
            }), true);
        }, [ [] ]);
    }

    formatInput(input){

        const ports = input.split(",").reduce( (table, val) => {
            const newTable = !val.includes("-") ? [...table , val] : [...table, _.range(val.split("-")[0], val.split("-")[1])]
            return [...table, newTable]
        }, []);


        var flattened = ports.reduce(function(a, b) {
            return a.concat(b);
        });

        var flat = [].concat.apply([], ports);
        var flat2 =  [].concat.apply([], flat);

        flat2 = flat2.filter(function( obj ) {
            return typeof obj !== typeof [];
        });

        let flat3 = flat2.map( (val) => {
            typeof val === 'string' ? val : val.toString()
            return val.toString()
        })

        let unique = [...new Set(flat3)].sort()

        return unique
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
                    <input type="text"
                           className="form-control"
                           placeholder="port"
                           name="port"
                           onChange={this.handleChange}
                    />
                </div>
                <div style={{ ...(dataSource.length > 0 ? { flex: 1 } : {}) }}>
                    <AutocompleteChips value={scann_type} onChange={this.handleChange} dataSource={dataSource} methods={this.methods} />
                </div>
                <RaisedButton label="Go!"
                              primary={true}
                              type="submit"
                              disabled={!submitButtonEnabled}
                              style={{ marginLeft: 5, ...(dataSource.length > 0 ? { width: 200 } : { flex: 1 }) }}/>

            </form>
        )
    };
};

export default HostForm