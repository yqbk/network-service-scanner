import React from 'react';
import {Tabs, Tab} from 'material-ui/Tabs';
import AppBar from 'material-ui/AppBar';
import Slider from 'material-ui/Slider';
import baseTheme from 'material-ui/styles/baseThemes/lightBaseTheme';
import getMuiTheme from 'material-ui/styles/getMuiTheme';
import injectTapEventPlugin from 'react-tap-event-plugin';

import FirstTab from './menu/FirstTab'
import SecondTab from './menu/SecondTab'
import ScannHistory from './menu/ScannHistory'
import SimpleScann from './menu/SimpleScann'


import {orange500} from 'material-ui/styles/colors';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';

import {
    blue500, orange700,
    pinkA200,
    grey100, grey300, grey400, grey500,
    white, darkBlack, fullBlack,
} from 'material-ui/styles/colors';

const muiTheme = getMuiTheme({
    palette: {
        primary1Color: blue500,
        primary2Color: orange700,
        primary3Color: grey400,
        accent1Color: orange700,
        accent2Color: grey100,
        accent3Color: grey500,
        textColor: darkBlack,
        alternateTextColor: white,
        canvasColor: white,
        borderColor: grey300,
        // disabledColor: fade(darkBlack, 0.3),
        pickerHeaderColor: orange500,
        // clockCircleColor: fade(darkBlack, 0.07),
        shadowColor: fullBlack,
    },
    appBar: {
        height: 50,
    },
});


export default class Main extends React.Component {

    constructor (props)
    {
        super(props)
        this.handleActive = this.handleActive.bind(this);
        injectTapEventPlugin();

        this.state = {
            hosts: props.data
        }
    }



    componentWillReceiveProps(nextProps) {
        // You don't have to do this check first, but it can help prevent an unneeded render
        if (nextProps.data !== this.state.hosts) {
            console.log("\n\nzmiana w main!!\n\n")
            this.setState({ hosts: nextProps.data });
        }
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

        <MuiThemeProvider muiTheme={muiTheme}>

            <Tabs>
                <Tab label="Scann" >
                    <div>
                        <h2>Scann network</h2>
                        <p>
                            Scann range of adresses or your current network to detect hosts, open ports and services running on them.
                        </p>
                        <FirstTab />
                        {/*<ScannHistory hosts={this.props.data}/>*/}
                    </div>
                </Tab>
                <Tab label="Active Hosts" >
                    <div>
                        <h2>Scann single host</h2>
                        <p>
                            Choose parameters to perform single scann on host or compare results of different scanning methods.
                        </p>
                        <SimpleScann />
                    </div>
                </Tab>
                <Tab label="Scann History" >
                    <div>
                        <h2>Scann History</h2>
                        <p>
                            History of detected hosts
                        </p>
                        <ScannHistory hosts={this.state.hosts}/>
                    </div>
                </Tab>
                <Tab label="About" >
                    <div>
                        <h2>About page</h2>
                        <p>
                            This is service scanner
                        </p>
                    </div>
                </Tab>

            </Tabs>
        </MuiThemeProvider>
        );
    }
}


Main.childContextTypes = {
    muiTheme: React.PropTypes.object.isRequired,
};
