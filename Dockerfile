# ใช้ Node.js เวอร์ชัน 18 เป็น Base Image
FROM node:18

# กำหนด working directory ใน container
WORKDIR /app

# คัดลอกไฟล์ package.json และ package-lock.json เข้ามาใน container
COPY package*.json ./
 
# ติดตั้ง dependencies
RUN npm install

# คัดลอกโค้ดทั้งหมดเข้ามาใน container
COPY . .

# กำหนดพอร์ตที่จะ expose ใน container
EXPOSE 8080

# รันแอปพลิเคชัน
CMD ["node", "server.js"]