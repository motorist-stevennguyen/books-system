require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { User.new(email: "reader@example.com", first_name: "Alex", last_name: "Doe") }

  describe "#welcome_email" do
    let(:mail) { described_class.welcome_email(user) }

    it "renders the headers" do
      expect(mail.to).to eq([ "lcng00001@gmail.com" ])
      expect(mail.subject).to eq("Welcome to Foodie")
    end

    it "stays under Gmail's ~102KB clipping limit" do
      html_size = mail.html_part.body.decoded.bytesize

      expect(html_size).to be <= ApplicationMailer::GMAIL_CLIP_LIMIT_BYTES
    end

    it "does not log a clipping warning" do
      expect(Rails.logger).not_to receive(:warn)

      mail.message
    end
  end

  describe "#clipping_demo" do
    let(:mail) { described_class.clipping_demo(user) }

    it "renders the headers" do
      expect(mail.to).to eq([ "lcng00001@gmail.com" ])
      expect(mail.subject).to eq("[Demo] Gmail Message Clipping")
    end

    it "reproduces Gmail's clipping condition on demand" do
      html_size = mail.html_part.body.decoded.bytesize

      expect(html_size).to be > ApplicationMailer::GMAIL_CLIP_LIMIT_BYTES
    end

    it "logs a clipping warning" do
      expect(Rails.logger).to receive(:warn).with(/HTML body is \d+ bytes/)

      mail.message
    end
  end
end
