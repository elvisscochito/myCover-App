const express = require('express');
const Stripe = require('stripe');
const bodyParser = require('body-parser');

const stripe = new Stripe('sk_test_51QaX3sIRGpN5HrMK8M2HfWerVxOZm6sv9EhVMYagTRh16PO2SMYgqHimjQxCcQvwno7uzzGigTXQff1GSgd24ZQw008ADzH3wS'); // Tu secret key de Stripe
const app = express();

app.use(bodyParser.json());

app.post('/create-intent', async (req, res) => {
    try {
        const { amount } = req.body; // La cantidad que cobrarás
        const paymentIntent = await stripe.paymentIntents.create({
            amount: amount, // En centavos (ej: 1099 = $10.99)
            currency: 'usd',
            automatic_payment_methods: { enabled: true },
        });
        res.json({ clientSecret: paymentIntent.client_secret });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
});

app.listen(3000, () => console.log('Servidor en http://localhost:3000'));
