import RWR from 'react-webpack-rails';
RWR.run();

import Main from './components/main';
RWR.registerComponent('Main', Main);

//
// import Hosts from './components/hosts';
// RWR.registerComponent('Hosts', Hosts);
//
// import Host from './components/host';
// RWR.registerComponent('Host', Host);
//
// import HostForm from './components/host_form';
// RWR.registerComponent('HostForm', HostForm);
