#!/bin/bash
# Simple deployment script for the Love App

echo "🔧 Installing required packages..."
sudo apt-get update
sudo apt-get install -y python3 python3-pip nginx

echo "📂 Setting up project directory..."
sudo mkdir -p /var/www/love-app
sudo cp -r . /var/www/love-app
sudo chown -R www-data:www-data /var/www/love-app

echo "🌐 Configuring Nginx..."
sudo bash -c 'cat > /etc/nginx/sites-available/love-app <<EOL
server {
    listen 80;
    server_name yourdomain.com;

    root /var/www/love-app;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";
}
EOL'

echo "🔗 Enabling site configuration..."
sudo ln -sf /etc/nginx/sites-available/love-app /etc/nginx/sites-enabled
sudo nginx -t && sudo systemctl restart nginx

echo "✅ Deployment complete!"
echo "🌍 Access the app at: http://yourdomain.com or your server IP"
echo "🔒 Remember to:"
echo "  1. Set up SSL/TLS (Let's Encrypt)"
echo "  2. Configure your domain DNS"
echo "  3. Set proper file permissions"