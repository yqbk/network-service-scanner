import React from 'react';
import {Tabs, Tab} from 'material-ui/Tabs';
import AppBar from 'material-ui/AppBar';
import Slider from 'material-ui/Slider';
import baseTheme from 'material-ui/styles/baseThemes/darkBaseTheme';
import getMuiTheme from 'material-ui/styles/getMuiTheme';
import injectTapEventPlugin from 'react-tap-event-plugin';

import TabOne from './menu/TabOne'




export default class Main extends React.Component {

    static childContextTypes =
    {
        muiTheme: React.PropTypes.object
    }

    getChildContext()
    {
        return {
            muiTheme: getMuiTheme()
        }
    }



    constructor (props)
    {
        super(props)
        this.handleActive = this.handleActive.bind(this);
        injectTapEventPlugin();

    }



    handleActive(tab) {
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
        }

        return (
            <Tabs>
                <Tab label="Scann" >
                    <TabOne hosts={this.props.data}/>
                </Tab>

                <Tab label="Single Scann" >
                    <div>
                        <h2>Tab Two</h2>
                        <p>
                            This is another example tab.
                        </p>
                    </div>
                </Tab>

                <Tab label="About" >
                    <div>
                        <h2>Tab Two</h2>
                        <p>
                            This is another example tab.
                        </p>
                    </div>
                </Tab>



            </Tabs>


        );


    }
}


Main.childContextTypes = {
    muiTheme: React.PropTypes.object.isRequired,
};
