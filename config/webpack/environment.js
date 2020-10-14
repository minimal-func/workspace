const { environment } = require('@rails/webpacker')

const webpack = require('webpack');

// environment.plugins.prepend('Provide', new webpack.ProvidePlugin({
//   "React": "react"
// }));

// environment.loaders.append('expose', {
//   test: require.resolve('react_ujs'),
//   use: [{
//     loader: 'expose-loader',
//     options: 'React'
//   }]
// });

module.exports = environment

