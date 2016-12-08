import React from 'react';
import {Tabs, Tab} from 'material-ui/Tabs';
import AppBar from 'material-ui/AppBar';
import Slider from 'material-ui/Slider';
import baseTheme from 'material-ui/styles/baseThemes/lightBaseTheme';
import getMuiTheme from 'material-ui/styles/getMuiTheme';
import injectTapEventPlugin from 'react-tap-event-plugin';

import FirstTab from './menu/FirstTab'
import SecondTab from './menu/SecondTab'


export default class Main extends React.Component {

    constructor (props)
    {
        super(props)
        this.handleActive = this.handleActive.bind(this);
        injectTapEventPlugin();
    }

    static childContextTypes =
    {
        muiTheme: React.PropTypes.object
    };

    getChildContext()
    {
        return {
            muiTheme: getMuiTheme()
        }
    }

    handleActive(tab)
    {
        alert(`A tab with this route property ${tab.props['data-route']} was activated.`);
    }

    render() {

        const styles = {
            headline: {
                fontSize: 24,
                paddingTop: 16,
                marginBottom: 12,
                fontWeight: 400,
            },
        };

        return (

            <Tabs>
                <Tab label="Scann" >
                    <div>
                        <h2>Scann network</h2>
                        <p>
                            Scann range of adresses or your current network to detect hosts, open ports and services running on them.
                        </p>
                        <FirstTab />
                        {/*<History hosts={this.props.data}/>*/}
                    </div>
                </Tab>
                <Tab label="Single Scann" >
                    <div>
                        <h2>Scann single host</h2>
                        <p>
                            Choose parameters to perform single scann on host or compare results of different scanning methods.
                        </p>
                        {/*<SecondTab hosts={this.props.data}/>*/}
                    </div>
                </Tab>
                <Tab label="History" >
                    <div>
                        <h2>History</h2>
                        <p>
                            History of detected hosts
                        </p>
                        {/*<History hosts={this.props.data}/>*/}
                    </div>
                </Tab>
            </Tabs>
        );
    }
}


Main.childContextTypes = {
    muiTheme: React.PropTypes.object.isRequired,
};
