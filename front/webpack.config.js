const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    entry: './src/index.tsx',
    devtool: 'source-map',
    module: {
        rules: [
            { test: /\.tsx?$/, use: 'awesome-typescript-loader', exclude: /node_modules/ },

            { enforce: "pre", test: /\.js$/, loader: "source-map-loader" }
        ]
    },
    
    resolve: {
        extensions: [".ts", ".tsx", ".js", ".json"]
    },

    output: {
        filename: "bundle.js",
        path: path.resolve(__dirname, 'dist')
    },
    devServer: {
        port: 8000,
        contentBase: "./dist"
    },
    plugins: [
        //Generate index.html in /dist => https://github.com/ampedandwired/html-webpack-plugin
        new HtmlWebpackPlugin({
          filename: 'index.html', //Name of file in ./dist/
          template: './src/index.html', //Name of template in ./src
          hash: true,
        })
      ],
};