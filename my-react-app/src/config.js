const config = {
    development: {
        apiUrl: 'http://localhost:8888'
    },
    production: {
        apiUrl: import.meta.env.VITE_API_URL
    }
}

export default config[import.meta.env.MODE];